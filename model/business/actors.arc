# Who works with ArchiCode. Roles in ArchiMate 4.0 belong to no layer, so an AI agent — a
# program — fills a role just as a person does.
imports:
  - motivation

elements:
  customer:
    type: business-actor
    name: Customer
    description: "A corporation that manages the architecture of its systems, with tens or hundreds of architects, and runs ArchiCode on its own infrastructure."
    relations:
      - type: assignment
        target: architect
      - type: assignment
        target: developer
      - type: assignment
        target: ai-engineer

  architect:
    type: role
    name: Architect
    description: "Designs the architecture as a model, on the canvas or as code, and promotes the changes."
    relations:
      - type: association
        target: motivation.enterprise-architect
      - type: association
        target: motivation.solution-architect
      - type: assignment
        target: edit-on-canvas
      - type: assignment
        target: edit-as-code
      - type: assignment
        target: commit-the-change

  developer:
    type: role
    name: Developer
    description: "Reads the architecture of their own area and changes it within that context, from a checkout."
    relations:
      - type: association
        target: motivation.developer
      - type: assignment
        target: edit-as-code
      - type: assignment
        target: commit-the-change

  ai-engineer:
    type: role
    name: AI engineer
    description: "States the model's rules — its fitness functions — and the properties they read."
    relations:
      - type: association
        target: motivation.ai-engineer
      - type: assignment
        target: edit-as-code

  ai-agent:
    type: role
    name: AI agent
    description: "An AI architect, developer or tester: reads the model's context and designs within its contracts, and never writes to the model."
    relations:
      - type: assignment
        target: read-the-context
