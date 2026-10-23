# The product's architectural principles, numbered as the architecture concept numbers them.
elements:
  git-is-the-source-of-truth:
    type: principle
    name: Git is the single source of truth
    description: "One model is one repository. Every authoritative write is a commit, and no architecture state exists anywhere else."
    properties:
      number: 1
    relations:
      - type: realization
        target: ownership-is-cheap

  stores-are-disposable:
    type: principle
    name: Every other store is derived and disposable
    description: "An index exists for speed, never for truth: it is rebuildable from the repository alone, and losing it loses nothing."
    properties:
      number: 2
    relations:
      - type: realization
        target: ownership-is-cheap

  product-data-apart:
    type: principle
    name: Product data and architecture data never mix
    description: "Accounts, sessions, permissions and audit records live apart from the architecture graph, and neither ever holds the other's data."
    properties:
      number: 3

  no-notation-in-the-core:
    type: principle
    name: The core knows no notation
    description: "Which types exist and which combinations are legal is data the model declares. Adding a notation is configuration, never a change to the core."
    properties:
      number: 4
    relations:
      - type: realization
        target: ownership-is-cheap

  meaning-by-hand:
    type: principle
    name: Meaning is hand-authored, presentation is machine-owned
    description: "The files a person writes keep their comments, ordering and formatting through every machine edit; geometry lives in files a machine owns."
    properties:
      number: 5
    relations:
      - type: realization
        target: ownership-is-cheap

  declared-appearance:
    type: principle
    name: Appearance is declared, never painted
    description: "Every colour traces back to a rule, so a diagram can explain why it looks the way it does."
    properties:
      number: 6
    relations:
      - type: realization
        target: ownership-is-cheap

  declarative-extension:
    type: principle
    name: Extension is declarative
    description: "A new notation, style or validation rule is a document the product validates as input. The product never loads third-party code to extend itself."
    properties:
      number: 7
    relations:
      - type: realization
        target: governance-is-automated

  fail-closed:
    type: principle
    name: Fail closed
    description: "An unknown type, an unresolved reference, a model without its notation: each stops the build. Nothing is silently defaulted, and nothing invalid reaches an agent."
    properties:
      number: 8
    relations:
      - type: realization
        target: governance-is-automated

  identity-is-the-path:
    type: principle
    name: Identity is the path
    description: "An element is identified by where it lives, so every reference is readable and every rename is a refactor the tooling performs."
    properties:
      number: 9
    relations:
      - type: realization
        target: ownership-is-cheap

  draft-then-promote:
    type: principle
    name: Draft locally, promote deliberately
    description: "Editing never commits per interaction. Work accumulates as a draft, and a person decides when it becomes history."
    properties:
      number: 10
    relations:
      - type: realization
        target: ownership-is-cheap

  one-model-three-surfaces:
    type: principle
    name: Three surfaces, one model
    description: "A terminal, a browser and an agent see the same model through the same compiler and the same rules."
    properties:
      number: 11
    relations:
      - type: realization
        target: architecture-is-ai-native

  agents-read-people-write:
    type: principle
    name: Agents read, people write
    description: "The product is a context source for agents, not a runner of them. Authority to change a model stays with a person."
    properties:
      number: 12
    relations:
      - type: realization
        target: architecture-is-ai-native
      - type: realization
        target: agents-coordinate-through-contracts

  one-customer-one-deployment:
    type: principle
    name: One customer, one deployment
    description: "Self-hosted and single-tenant, released and deployed as one unit. There is no shared instance."
    properties:
      number: 13
    relations:
      - type: realization
        target: ownership-is-cheap

  minimal-metamodel:
    type: principle
    name: The metamodel holds only what the core computes with
    description: "Identity, type, visibility, relations, views. Everything an organisation records about the world is a typed property checked by a rule."
    properties:
      number: 14
    relations:
      - type: realization
        target: architecture-is-ai-native

  integrations-enrich:
    type: principle
    name: Integrations enrich, they do not own
    description: "An external system may be read to decorate a model; it never becomes a source of architecture truth."
    properties:
      number: 15
