# How the architecture changes: on the canvas or as code, one commit either way, and then the
# model's rules and its agents' context both follow the commit.
imports:
  - strategy

elements:
  change-the-architecture:
    type: process
    name: Change the architecture
    description: "From an edit to a commit the model's rules have checked and its agents can read."
    relations:
      - type: composition
        target: edit-on-canvas
      - type: composition
        target: edit-as-code
      - type: composition
        target: commit-the-change
      - type: composition
        target: lint-in-ci
      - type: composition
        target: refresh-the-context
      - type: realization
        target: architecture-modeling
      - type: realization
        target: strategy.modeling-as-code

  edit-on-canvas:
    type: process
    name: Edit on the canvas
    description: "Places, moves, nests and lays out elements in views. The changes stay in a draft in the browser."
    relations:
      - type: triggering
        target: edited
      - type: access
        target: view
        properties: { access-type: readwrite }

  edit-as-code:
    type: process
    name: Edit as code
    description: "Changes *.arc files and configuration documents in an editor, linting the checkout before committing."
    relations:
      - type: triggering
        target: edited
      - type: access
        target: architecture-model
        properties: { access-type: readwrite }
      - type: access
        target: fitness-function
        properties: { access-type: readwrite }

  commit-the-change:
    type: process
    name: Commit the change
    description: "One commit on the model's branch, authored as the person: a promote from the canvas, or a push from a checkout. The git host may refuse it."
    relations:
      - type: triggering
        target: committed
      - type: access
        target: architecture-model
        properties: { access-type: write }

  lint-in-ci:
    type: process
    name: Lint in CI
    description: "Compiles and lints the commit; an error finding fails the build."
    relations:
      - type: access
        target: fitness-function
        properties: { access-type: read }
      - type: realization
        target: architecture-governance
      - type: realization
        target: strategy.architecture-governance

  refresh-the-context:
    type: process
    name: Refresh the context
    description: "The deployment fetches the commit, compiles the model and writes it into the read model, so that every reader sees the new state."
    relations:
      - type: access
        target: architecture-model
        properties: { access-type: read }

  read-the-context:
    type: process
    name: Read the context
    description: "An agent searches the model, follows its relations, measures an impact and reads the context before it designs or writes code."
    relations:
      - type: access
        target: architecture-model
        properties: { access-type: read }
      - type: realization
        target: architecture-context
      - type: realization
        target: strategy.ai-context

  architecture-model:
    type: business-object
    name: Architecture model
    description: "The architecture of the customer's systems as one model: elements, relations, views and rules, in one git repository."

  view:
    type: business-object
    name: View
    description: "A diagram: a projection of the model that places elements and draws relations, laid out by a machine."

  fitness-function:
    type: business-object
    name: Fitness function
    description: "A constraint that executes: a rule the model states about itself, checked on every change."

junctions:
  # Either way of editing ends in the same commit.
  edited:
    kind: or
    relations:
      - type: triggering
        target: commit-the-change

  # A commit sets off both the check and the refresh.
  committed:
    kind: and
    relations:
      - type: triggering
        target: lint-in-ci
      - type: triggering
        target: refresh-the-context
