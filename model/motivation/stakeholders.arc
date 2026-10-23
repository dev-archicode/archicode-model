# Who ArchiCode is for, and what hurts them today. The motivation layer imports nothing: the
# layers below realize it, never the other way round.
elements:
  product-visionary:
    type: stakeholder
    name: Product visionary
    description: "Defines business goals and business context for AI agents, and prioritises the requirements."
    relations:
      - type: association
        target: ai-agents-are-blind

  ai-engineer:
    type: stakeholder
    name: AI engineer
    description: "Designs the architectural context agents get and the governance they work under: contracts, fitness functions."
    relations:
      - type: association
        target: ai-agents-are-blind
      - type: association
        target: no-governance-for-agents

  enterprise-architect:
    type: stakeholder
    name: Enterprise architect
    description: "Manages the IT landscape, target architectures and principles, and supports leadership's decisions."
    relations:
      - type: association
        target: documentation-is-dead

  solution-architect:
    type: stakeholder
    name: Solution architect
    description: "Designs solutions as a model, from requirements through design to code, and keeps the as-built catalog."
    relations:
      - type: association
        target: modeling-is-drudgery
      - type: association
        target: architecture-drift

  developer:
    type: stakeholder
    name: Developer
    description: "Needs the architectural context of their own area, in their IDE, to make targeted changes."
    relations:
      - type: association
        target: documentation-is-dead

  systems-analyst:
    type: stakeholder
    name: Systems analyst
    description: "Links requirements to the architectural elements that meet them, and reports on it."
    relations:
      - type: association
        target: no-traceability

  ai-agents-are-blind:
    type: driver
    name: AI agents are blind
    description: "Agents have no access to architectural decisions, contracts or constraints."
    relations:
      - type: influence
        target: architecture-is-ai-native

  no-governance-for-agents:
    type: driver
    name: No governance for agents
    description: "AI assistants generate code without understanding the architectural context they work in."
    relations:
      - type: influence
        target: governance-is-automated
      - type: influence
        target: agents-coordinate-through-contracts

  architecture-drift:
    type: driver
    name: Architecture drift
    description: "A chasm between what was designed and what is implemented."
    relations:
      - type: influence
        target: design-meets-implementation

  documentation-is-dead:
    type: driver
    name: Documentation is dead
    description: "Diagrams become obsolete as soon as they are drawn."
    relations:
      - type: influence
        target: ownership-is-cheap
      - type: influence
        target: design-meets-implementation

  modeling-is-drudgery:
    type: driver
    name: Modeling is manual drudgery
    description: "Modeling is painstaking work in a drawing tool, with no connection to the code."
    relations:
      - type: influence
        target: ownership-is-cheap

  no-traceability:
    type: driver
    name: No traceability
    description: "Nothing leads from a requirement to the component that meets it, and on to the service it runs as."
    relations:
      - type: influence
        target: design-meets-implementation
