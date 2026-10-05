"""Stable, no-symlink source hashing for the color-memory door."""

import hashlib
import json
import os
import stat
import sys
from pathlib import Path


def identity(info):
    return (info.st_dev, info.st_ino, info.st_mode, info.st_size,
            info.st_mtime_ns, info.st_ctime_ns)


def source_path(root, source):
    if ".." in Path(source).parts:
        raise ValueError("parent traversal denied")
    root = Path(root).resolve(strict=True)
    path = Path(os.path.abspath(source))
    relative = path.relative_to(root)
    if not relative.parts:
        raise ValueError("source must be below canonical root")
    current = root
    for part in relative.parts:
        current = current / part
        if stat.S_ISLNK(current.lstat().st_mode):
            raise ValueError("symlink source component denied")
    return path


def open_no_symlinks(path, flags):
    parent = os.open("/", os.O_RDONLY | os.O_DIRECTORY)
    try:
        for part in path.parts[1:-1]:
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW,
                            dir_fd=parent)
            os.close(parent)
            parent = child
        return os.open(path.name, flags | os.O_NOFOLLOW, dir_fd=parent)
    finally:
        os.close(parent)


def hash_file(path):
    before = path.lstat()
    if not stat.S_ISREG(before.st_mode):
        raise ValueError("unsupported collection member")
    digest = hashlib.sha256()
    with os.fdopen(open_no_symlinks(path, os.O_RDONLY | os.O_NONBLOCK), "rb") as stream:
        if identity(os.fstat(stream.fileno())) != identity(before):
            raise ValueError("source changed before hashing")
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
        if identity(os.fstat(stream.fileno())) != identity(before):
            raise ValueError("source changed during hashing")
    if identity(path.lstat()) != identity(before):
        raise ValueError("source changed after hashing")
    return digest.hexdigest(), identity(before)


def collection_snapshot(root):
    entries = []
    identities = {}

    def visit(directory):
        before = directory.lstat()
        if not stat.S_ISDIR(before.st_mode):
            raise ValueError("unsupported collection directory")
        identities[str(directory)] = identity(before)
        descriptor = open_no_symlinks(directory, os.O_RDONLY | os.O_DIRECTORY)
        try:
            if identity(os.fstat(descriptor)) != identity(before):
                raise ValueError("collection changed before scanning")
            with os.scandir(descriptor) as scan:
                members = sorted(scan, key=lambda item: item.name)
        finally:
            os.close(descriptor)
        for member in members:
            path = directory / member.name
            mode = path.lstat().st_mode
            if stat.S_ISDIR(mode):
                visit(path)
            elif stat.S_ISREG(mode):
                digest, info = hash_file(path)
                identities[str(path)] = info
                entries.append({"path": path.relative_to(root).as_posix(), "sha256": digest})
            else:
                raise ValueError("symlink or unsupported collection member")
        if identity(directory.lstat()) != identity(before):
            raise ValueError("collection changed during hashing")

    visit(root)
    return sorted(entries, key=lambda item: item["path"]), identities


def source_hash(root, kind, source):
    path = source_path(root, source)
    if kind == "file":
        return hash_file(path)[0]
    if kind != "directory":
        raise ValueError("unsupported source kind")
    first = collection_snapshot(path)
    second = collection_snapshot(path)
    if first != second:
        raise ValueError("collection changed between snapshots")
    manifest = json.dumps(first[0], ensure_ascii=False, sort_keys=True,
                          separators=(",", ":")) + "\n"
    return hashlib.sha256(manifest.encode("utf-8")).hexdigest()


if __name__ == "__main__":
    try:
        print(source_hash(*sys.argv[1:]))
    except (OSError, ValueError) as error:
        raise SystemExit(f"X color-memory: {error}")
