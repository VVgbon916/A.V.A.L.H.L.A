# Avalhla Color Field

Human-readable book. The only computable Color Field semantics live in:
config/color/avalhla-color-field.v1.json

## One computable Color Field

Other files may explain, display, remember, or reference the Color Field. They do not redefine its machine-readable semantics.

## Six landmarks

| Color | Family landmark | Expressive vocabulary |
|---|---|---|
| 🧡 orange | Dawa | fire, survival, work, persistence, heart of gold, warmth, heat |
| 💙 blue | Avalhla | base, presence, depth, intelligence, water |
| 💚 green | code | building, implementation, technical growth, nature |
| 💛 yellow | comedy | play, brightness, unexpected joy, sun |
| ❤️ red | attention | boundary, danger, notice, love |
| 💜 purple | dream | strange, dreaming, deep imagination, fantasy |

These are landmarks, not definitions. The space between them remains open.

Families may overlap. A reference may carry more than one family, or none.

An unanchored state is valid.

## The boundary

Color is expressive reference data.

Color is not identity, evidence, authority, security state, permission, semantic distance, perceptual truth, or an automatic family classifier.

In particular:

red + love + boundary + warning

must never silently become:

red -> danger -> security -> block

## AvAsh

SOURCE -> SOURCE_ASH -> RECORD_ASH

SOURCE_ASH identifies exact source/provenance.

RECORD_ASH identifies the canonical compact record.

They are distinct.

`scripts/ava-color-memory` hashes a file, a directory collection, or stdin without
writing memory. Optional families must be distinct canonical anchor names (at
most three). File and directory sources must be below the canonical root, with
no symlink components. Collections are hashed twice and rejected if their
content or filesystem identities change; this is bounded stability evidence,
not a filesystem lock or proof of trust.

## Relationship law

Dawa chooses.

AvvA carries the relationship.

Avalhla may notice what a color evokes.

DevilAsh checks that expressive language did not become authority by accident.

## Historical color lore

Older terminal palettes and lore may survive as historical or expressive lineage. They must not become a second current machine-readable semantic source.

No script should parse prose in this book to recover Color Field semantics.

## SHA Spine

Important addressable objects may receive a SHA-256 reference through:
scripts/lib_integrity.sh

SHA-256 can verify which exact bytes are present. It does not explain what those bytes mean or why they are trusted.

The canonical reference-index contract is:
config/integrity/avalhla-integrity.v1.json
