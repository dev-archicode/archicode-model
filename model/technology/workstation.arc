# Outside the chart: the local surfaces, run against a checkout. They are unauthenticated,
# since whoever can read the repository on their machine has the model already.
imports:
  - application.backend
  - motivation
  - application.data

elements:
  workstation:
    type: device
    name: Workstation
    description: "A person's machine with a checkout of a model, where the CLI runs and a local agent starts the MCP server over stdio."
    relations:
      - type: assignment
        target: cli-jar
      - type: assignment
        target: mcp-jar
      - type: assignment
        target: model-checkout
      - type: assignment
        target: embedded-index

  ci-runner:
    type: node
    name: CI runner
    description: "Lints the model on every change and fails the build on an error: the model's fitness functions, executed."
    properties:
      realization-status: develop
    relations:
      - type: assignment
        target: cli-jar
      - type: assignment
        target: model-checkout
      - type: realization
        target: motivation.fr-m11

  cli-jar:
    type: artifact
    name: cli.jar
    properties:
      realization-status: develop
      path: cli/build/libs/cli-0.1.0-SNAPSHOT.jar
    relations:
      - type: realization
        target: application.backend.cli

  mcp-jar:
    type: artifact
    name: mcp.jar
    properties:
      realization-status: develop
      path: mcp/build/libs/mcp-0.1.0-SNAPSHOT.jar
    relations:
      - type: realization
        target: application.backend.mcp

  model-checkout:
    type: artifact
    name: Model checkout
    description: "A git working copy of a model repository: the manifest, model/, views/ and config/."
    properties:
      realization-status: develop
    relations:
      - type: realization
        target: motivation.git-is-the-source-of-truth
      - type: realization
        target: application.data.manifest
      - type: realization
        target: application.data.model-source
      - type: realization
        target: application.data.configuration-document
      - type: realization
        target: application.data.rules-document
      - type: realization
        target: application.data.view-document

  embedded-index:
    type: artifact
    name: Embedded index
    description: "The files of the Neo4j engine embedded in the MCP server, under build/neo4j-index unless configured otherwise. Rebuilt from the checkout when lost."
    properties:
      realization-status: develop
      path: build/neo4j-index
      disposable: true
    relations:
      - type: realization
        target: application.backend.graph-index
      - type: realization
        target: motivation.stores-are-disposable

  corporate-network:
    type: communication-network
    name: Corporate network
    description: "The customer's network: the cluster, CI and people's machines reach the git hosts and the identity provider over it."
    relations:
      - type: association
        target: kubernetes
      - type: association
        target: ci-runner
      - type: association
        target: workstation
