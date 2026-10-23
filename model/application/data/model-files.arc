# What a model repository holds, file by file (the workspace's repository-layout contract).
imports:
  - business

elements:
  manifest:
    type: data-object
    name: Manifest
    description: "archicode.yml at the repository's root: the model's name, version and notation, and nothing else."
    relations:
      - type: realization
        target: business.architecture-model

  model-source:
    type: data-object
    name: Model source
    description: "The *.arc files under model/: a package per folder, its elements with their relations, its junctions."
    relations:
      - type: realization
        target: business.architecture-model

  configuration-document:
    type: data-object
    name: Configuration document
    description: "A document under config/: specializations, enum dictionaries, property declarations or a stylesheet."
    relations:
      - type: realization
        target: business.architecture-model

  rules-document:
    type: data-object
    name: Rules document
    description: "A document under config/rules/: the model's validation rules and the tuning of the built-in checks."
    relations:
      - type: realization
        target: business.fitness-function

  view-document:
    type: data-object
    name: View document
    description: "A *.view.json under views/: what a view places and draws, with its geometry. Written by a machine, in one canonical form."
    relations:
      - type: realization
        target: business.view
