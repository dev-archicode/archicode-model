elements:
  archicode:
    type: product
    name: ArchiCode
    description: "Architecture as AI context: a model in git that people design and agents read."
    relations:
      - type: aggregation
        target: architecture-modeling
      - type: aggregation
        target: architecture-governance
      - type: aggregation
        target: architecture-context

  architecture-modeling:
    type: service
    name: Architecture modeling
    description: "Design and change the architecture as a model, as code or on a canvas."
    relations:
      - type: serving
        target: architect
      - type: serving
        target: developer

  architecture-governance:
    type: service
    name: Architecture governance
    description: "Every change checked against the model's own rules before anyone builds on it."
    relations:
      - type: serving
        target: ai-engineer
      - type: serving
        target: architect

  architecture-context:
    type: service
    name: Architecture context
    description: "The architecture as context an agent reads and complies with."
    relations:
      - type: serving
        target: ai-agent
