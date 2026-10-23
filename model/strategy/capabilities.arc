# What ArchiCode enables, independent of how it is built. A capability still on the roadmap
# names its roadmap item.
imports:
  - motivation

elements:
  modeling-as-code:
    type: capability
    name: Modeling as code
    description: "The architecture as text in git: a declarative DSL, a notation as data, one model per repository, validated on every change."
    relations:
      - type: realization
        target: motivation.ownership-is-cheap

  architecture-governance:
    type: capability
    name: Architecture governance
    description: "Fitness functions as code: the model's own rules, checked on every surface and failing the build when violated."
    properties:
      roadmap: ROAD-05
    relations:
      - type: realization
        target: motivation.governance-is-automated

  ai-context:
    type: capability
    name: Architecture as AI context
    description: "Search, relations, impact and context over MCP, so that an agent designs within the architecture instead of guessing it."
    relations:
      - type: realization
        target: motivation.architecture-is-ai-native
      - type: realization
        target: motivation.agents-coordinate-through-contracts

  visualization:
    type: capability
    name: Visualization
    description: "Views drawn from the model, laid out by a machine and styled by declared rules."
    properties:
      roadmap: ROAD-03

  impact-analysis:
    type: capability
    name: Impact analysis
    description: "What depends on an element, directly or through the relations the model implies."
    properties:
      roadmap: ROAD-03
    relations:
      - type: realization
        target: motivation.architecture-is-ai-native

  as-built-catalog:
    type: capability
    name: As-built catalog
    description: "What actually runs — owners, repositories, environments — mapped to the model, with the drift between them."
    properties:
      roadmap: ROAD-06
    relations:
      - type: realization
        target: motivation.design-meets-implementation
