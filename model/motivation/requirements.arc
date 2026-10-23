# A selection of the product's requirements, with the ids and the status the traceability
# matrix gives them. Whatever realizes one declares it, in the layer below.
elements:
  fr-m3:
    type: requirement
    name: Declarative DSL with strict validation and a linter
    properties:
      ref: FR-M3
      status: implemented

  fr-m7:
    type: requirement
    name: Validation rules as declarative rules documents
    properties:
      ref: FR-M7
      status: implemented
    relations:
      - type: realization
        target: governance-is-automated

  fr-m9:
    type: requirement
    name: AI context from the model, accessible over MCP
    properties:
      ref: FR-M9
      status: implemented
    relations:
      - type: realization
        target: architecture-is-ai-native

  fr-m11:
    type: requirement
    name: Fitness functions checked automatically, in CI/CD
    properties:
      ref: FR-M11
      status: future
      roadmap: ROAD-05
    relations:
      - type: realization
        target: governance-is-automated

  fr-m14:
    type: requirement
    name: Editor assistance in the web code mode and a VS Code extension
    properties:
      ref: FR-M14
      status: future
      roadmap: ROAD-11

  fr-v4:
    type: requirement
    name: Interactive web view with navigation, search and filtering
    properties:
      ref: FR-V4
      status: implemented

  fr-a3:
    type: requirement
    name: Connecting external git repositories
    properties:
      ref: FR-A3
      status: implemented

  fr-a8:
    type: requirement
    name: Several models per deployment, switched without signing in again
    properties:
      ref: FR-A8
      status: implemented

  fr-k4:
    type: requirement
    name: As-designed versus as-built drift detection
    properties:
      ref: FR-K4
      status: future
      roadmap: ROAD-06
    relations:
      - type: realization
        target: design-meets-implementation

  nfr-s7:
    type: requirement
    name: MCP access over local stdio
    properties:
      ref: NFR-S7
      status: implemented

  nfr-p6:
    type: requirement
    name: Git as the source of truth, a read model as a derived store
    properties:
      ref: NFR-P6
      status: implemented
    relations:
      - type: realization
        target: ownership-is-cheap

  nfr-c4:
    type: requirement
    name: Air-gapped, self-hosted container deployment
    properties:
      ref: NFR-C4
      status: future
      roadmap: ROAD-08
