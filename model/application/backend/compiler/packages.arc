# The compiler's Java packages, dev.archicode.compiler.*, and the stages of a compilation.
imports:
  - application.backend
  - motivation
  - application.data

elements:
  # A package that another package or module imports serves it, so the serving relations below are the
  # compiler's package graph and what each module takes from it. The frozen CLI and MCP server keep what they
  # used, their sources naming packages that have since moved.

  arc:
    type: application-component
    name: Arc
    description: "Reads an *.arc file against its shape — its imports, elements, junctions and relations — into the model, and records where each was written."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/arc
    relations:
      - type: serving
        target: pipeline
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.model-service
      - type: assignment
        target: parse
      - type: access
        target: application.data.model-source
        properties: { access-type: read }

  configuration:
    type: application-component
    name: Configuration
    description: "Reads the specializations, enum dictionaries and property declarations under config/ against the notation."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/configuration
    relations:
      - type: serving
        target: pipeline
      - type: assignment
        target: parse
      - type: access
        target: application.data.configuration-document
        properties: { access-type: read }

  context:
    type: application-component
    name: Context
    description: "Renders a compiled model, or a slice of it, as context for an AI agent."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/context
    relations:
      - type: serving
        target: application.backend.cli
      - type: serving
        target: application.backend.mcp
      - type: realization
        target: motivation.fr-m9

  derivation:
    type: application-component
    name: Derivation
    description: "Derives the relations a model implies from the ones it states, by the rules its notation declares, each by the shortest chain of stated relations. From a base it derives again only what a change reaches."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/model/derivation
    relations:
      - type: serving
        target: pipeline
      - type: serving
        target: style
      - type: serving
        target: view
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.storage-index
      - type: serving
        target: application.backend.storage-model
      - type: assignment
        target: derive

  diagnostic:
    type: application-component
    name: Diagnostic
    description: "What compilation reports: one diagnostic — its code, its severity, the subject it is about and where it is."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/diagnostic
    relations:
      - type: serving
        target: arc
      - type: serving
        target: configuration
      - type: serving
        target: document
      - type: serving
        target: layout
      - type: serving
        target: linter
      - type: serving
        target: manifest
      - type: serving
        target: notation
      - type: serving
        target: outline
      - type: serving
        target: pipeline
      - type: serving
        target: resolver
      - type: serving
        target: rules
      - type: serving
        target: selector
      - type: serving
        target: style
      - type: serving
        target: view
      - type: serving
        target: application.backend.cli
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.mcp
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.storage-model

  document:
    type: application-component
    name: Document
    description: "Reads a model's own documents — YAML, and the JSON of a view — through their shapes and reports their problems, and checks the schema version each declares."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/document
    relations:
      - type: serving
        target: arc
      - type: serving
        target: configuration
      - type: serving
        target: manifest
      - type: serving
        target: rules
      - type: serving
        target: style
      - type: serving
        target: view

  draft:
    type: application-component
    name: Draft
    description: "What the readers of a model's documents have found so far, which becomes the model once, when reading is done."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/model/draft
    relations:
      - type: serving
        target: linter
      - type: serving
        target: pipeline
      - type: serving
        target: resolver
      - type: assignment
        target: parse
      - type: assignment
        target: assemble

  graph:
    type: application-component
    name: Graph
    description: "The index of a resolved model — its relations and chains through junctions, containment hierarchies and packages — and the graph algorithms over it."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/model/graph
    relations:
      - type: serving
        target: context
      - type: serving
        target: derivation
      - type: serving
        target: draft
      - type: serving
        target: linter
      - type: serving
        target: pipeline
      - type: serving
        target: resolver
      - type: serving
        target: rules
      - type: serving
        target: selector
      - type: serving
        target: style
      - type: serving
        target: view
      - type: serving
        target: application.backend.model-service

  json:
    type: application-component
    name: Json
    description: "Reads a JSON document's tokens into the tree a shape is read over, keeping where each value starts and bounding the document's size and depth."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/json
    relations:
      - type: serving
        target: document

  layout:
    type: application-component
    name: Layout
    description: "Classifies every file of a repository against the reserved folders — model/, views/ and config/ — and reports what has no place."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/layout
    relations:
      - type: serving
        target: configuration
      - type: serving
        target: pipeline
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.storage-model
      - type: assignment
        target: parse
      - type: access
        target: application.data.model-source
        properties: { access-type: read }

  linter:
    type: application-component
    name: Linter
    description: "Describes each built-in check once, and what a model may tune about it; runs the built-in checks over a resolved model, the notation's rules among them, each for the subjects a change affects."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/model/linter
    relations:
      - type: serving
        target: pipeline
      - type: serving
        target: rules
      - type: serving
        target: application.backend.model-service
      - type: assignment
        target: lint

  manifest:
    type: application-component
    name: Manifest
    description: "Reads the manifest: the model's name, version and notation."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/manifest
    relations:
      - type: serving
        target: layout
      - type: serving
        target: pipeline
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.storage-model
      - type: assignment
        target: parse
      - type: access
        target: application.data.manifest
        properties: { access-type: read }

  notation:
    type: application-component
    name: Notation
    description: "Loads a notation definition and checks it against its schema: the vocabulary, the rules, the derivations."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/notation
    relations:
      - type: serving
        target: manifest
      - type: serving
        target: outline
      - type: serving
        target: pipeline
      - type: serving
        target: style
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.storage-model
      - type: realization
        target: motivation.no-notation-in-the-core
      - type: realization
        target: motivation.declarative-extension

  outline:
    type: application-component
    name: Outline
    description: "One document of the configuration read on its own, by its kind's shape and nothing else: its declarations as written, each with the line it starts at, and the problems of that document alone — what the configuration page shows, which needs no compilation."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/outline
    relations:
      - type: serving
        target: configuration
      - type: serving
        target: manifest
      - type: serving
        target: pipeline
      - type: serving
        target: rules
      - type: serving
        target: style
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.model-service

  pipeline:
    type: application-component
    name: Pipeline
    description: "The compiler's entry point: runs the stages in order, over a base — the compiled model of an earlier state of the same model — or over none. A file whose content is the base's is not read again, and each stage computes again, from what it last ran on, only what a change affects, so that the result is the one a compilation of all the files gives. A stage that builds ends the compilation when it finds an error, the checks always run, and what derives runs only on a model without errors."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/pipeline
    relations:
      - type: serving
        target: application.backend.cli
      - type: serving
        target: application.backend.compare
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.language-service
      - type: serving
        target: application.backend.mcp
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.service-support
      - type: serving
        target: application.backend.storage-index
      - type: serving
        target: application.backend.storage-model
      - type: assignment
        target: compile
      - type: realization
        target: motivation.fail-closed

  position:
    type: application-component
    name: Position
    description: "Where each declaration and value was read — a span, the subject it belongs to — and the index that maps one to the other."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/position
    relations:
      - type: serving
        target: arc
      - type: serving
        target: configuration
      - type: serving
        target: diagnostic
      - type: serving
        target: document
      - type: serving
        target: json
      - type: serving
        target: linter
      - type: serving
        target: notation
      - type: serving
        target: pipeline
      - type: serving
        target: reader
      - type: serving
        target: resolver
      - type: serving
        target: rules
      - type: serving
        target: selector
      - type: serving
        target: style
      - type: serving
        target: view
      - type: serving
        target: yaml
      - type: serving
        target: application.backend.cli
      - type: serving
        target: application.backend.compare
      - type: serving
        target: application.backend.language
      - type: serving
        target: application.backend.mcp
      - type: serving
        target: application.backend.model-service
      - type: serving
        target: application.backend.storage-model

  reader:
    type: application-component
    name: Reader
    description: "Reads a document against its shape: interprets the shape over the tree a front end built from the document, and reports every problem at the span of the value it is about."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/reader
    relations:
      - type: serving
        target: arc
      - type: serving
        target: configuration
      - type: serving
        target: document
      - type: serving
        target: json
      - type: serving
        target: manifest
      - type: serving
        target: notation
      - type: serving
        target: rules
      - type: serving
        target: selector
      - type: serving
        target: style
      - type: serving
        target: view
      - type: serving
        target: yaml

  resolver:
    type: application-component
    name: Resolver
    description: "Resolves every reference against the model: fully qualified names, imports and visibility."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/model/resolver
    relations:
      - type: serving
        target: pipeline
      - type: assignment
        target: resolve
      - type: realization
        target: motivation.identity-is-the-path

  rules:
    type: application-component
    name: Rules
    description: "Reads a model's validation rules and the tuning of the built-in checks, binds them to the resolved model, and evaluates the rules."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/rules
    relations:
      - type: serving
        target: context
      - type: serving
        target: pipeline
      - type: serving
        target: application.backend.model-service
      - type: assignment
        target: bind
      - type: assignment
        target: evaluate-rules
      - type: realization
        target: motivation.declarative-extension
      - type: realization
        target: motivation.fr-m7
      - type: access
        target: application.data.rules-document
        properties: { access-type: read }

  schema:
    type: application-component
    name: Schema
    description: "The declarative shapes every document is read through, rejecting any key a shape does not define."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/schema
    relations:
      - type: serving
        target: arc
      - type: serving
        target: configuration
      - type: serving
        target: document
      - type: serving
        target: json
      - type: serving
        target: manifest
      - type: serving
        target: notation
      - type: serving
        target: pipeline
      - type: serving
        target: reader
      - type: serving
        target: rules
      - type: serving
        target: selector
      - type: serving
        target: style
      - type: serving
        target: view
      - type: serving
        target: yaml
      - type: serving
        target: application.backend.language

  selector:
    type: application-component
    name: Selector
    description: "Binds and evaluates selectors, which validation rules and stylesheets share."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/selector
    relations:
      - type: serving
        target: rules
      - type: serving
        target: style
      - type: serving
        target: application.backend.model-service

  style:
    type: application-component
    name: Style
    description: "Binds the stylesheets and resolves the style of an element or a relation in a view."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/style
    relations:
      - type: serving
        target: pipeline
      - type: serving
        target: application.backend.model-service
      - type: assignment
        target: bind
      - type: realization
        target: motivation.declared-appearance

  view:
    type: application-component
    name: View
    description: "Parses view documents, checks them against the model, and writes them in their canonical form."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/format/view
    relations:
      - type: serving
        target: pipeline
      - type: serving
        target: application.backend.model-service
      - type: assignment
        target: check-views
      - type: realization
        target: motivation.meaning-by-hand
      - type: access
        target: application.data.view-document
        properties: { access-type: readwrite }

  yaml:
    type: application-component
    name: Yaml
    description: "Reads a YAML document safely — within its limits, under the core schema — into the tree a shape is read over, keeping where each value was written."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/yaml
    relations:
      - type: serving
        target: document
      - type: serving
        target: patch
      - type: serving
        target: notation
      - type: serving
        target: style

  patch:
    type: application-component
    name: Patch
    description: "Changes a YAML document where a person changed it: an edit is a place in the document — keys and indexes — and an operation on it, applied to the text by the composed nodes' marks so that every byte outside the edited lines stays as it was, a comment above an entry going with it, and a value written anew in the document's own indentation and style."
    properties:
      realization-status: develop
      path: compiler/src/main/java/dev/archicode/compiler/text/patch
    relations:
      - type: serving
        target: rules
      - type: serving
        target: selector
      - type: serving
        target: style
      - type: serving
        target: application.backend.model-service
      - type: realization
        target: motivation.meaning-by-hand

  # Compilation, stage by stage, in the order CompilerPipeline runs them, and the compiled model each
  # compilation starts from and answers.

  compile:
    type: process
    name: Compile a model
    description: "Turns a model's files into a resolved and linted model with its derived relations, or into the errors that stop it. It starts from a base — the compiled model of an earlier revision of the same model — or from none, through the same stages either way: each computes again, from what it last ran on, only what the change affects, and with no base everything is affected. Whatever the base, the answer is the one a compilation of all the files gives."
    relations:
      - type: composition
        target: parse
      - type: composition
        target: assemble
      - type: composition
        target: resolve
      - type: composition
        target: bind
      - type: composition
        target: lint
      - type: composition
        target: evaluate-rules
      - type: composition
        target: derive
      - type: composition
        target: check-views
      - type: access
        target: compiled-model
        id: base
        name: base
        description: "The compiled model of an earlier revision of the same model, when the caller holds one; a compilation from none is the same code with every file new."
        properties: { access-type: read }
      - type: access
        target: compiled-model
        id: result
        name: result
        description: "What the compilation answers, which the next compilation of the model may start from."
        properties: { access-type: write }

  parse:
    type: process
    name: Parse
    description: "Reads the manifest, the notation and the configuration, then each package file, view, rules document and stylesheet on its own into a unit of that file, against the notation and the file's path alone. A file whose content id is the base's, under the base's manifest, keeps the base's unit and is not read again; a changed manifest reuses nothing. Stops if the notation or the configuration cannot be read, and otherwise reports every problem the documents hold."
    relations:
      - type: triggering
        target: assemble
      - type: access
        target: application.data.manifest
        properties: { access-type: read }
      - type: access
        target: application.data.configuration-document
        properties: { access-type: read }
      - type: access
        target: application.data.model-source
        properties: { access-type: read }
      - type: access
        target: application.data.view-document
        properties: { access-type: read }
      - type: access
        target: application.data.rules-document
        properties: { access-type: read }

  assemble:
    type: process
    name: Assemble
    description: "Puts the files' units together in path order into the draft and the source index. What two files declare twice is found here: the first in path order is kept, and the repeat is reported at its own place."
    relations:
      - type: triggering
        target: resolve

  resolve:
    type: process
    name: Resolve
    description: "Resolves every type and reference, and enforces imports and visibility. From a base it resolves again the relations of the changed files and those that name an element or junction added, removed or made private or public, and checks again the imports of the files that import a package that appeared or went."
    relations:
      - type: triggering
        target: bind

  bind:
    type: process
    name: Bind rules and styles
    description: "Binds the model's validation rules and stylesheets to the resolved model, since their selectors name its packages and elements; whole on every compilation, which is cheap."
    relations:
      - type: triggering
        target: lint

  lint:
    type: process
    name: Lint
    description: "Runs the built-in checks, among them the integrity of a model's junctions and the notation's rules; an error finding is fatal. Each check declares what it is about — a relation, a junction, an element, a file, a package or the model —, and from a base runs again only for the subjects the change affects; a check whose tuning changed runs whole."
    relations:
      - type: triggering
        target: evaluate-rules

  evaluate-rules:
    type: process
    name: Evaluate rules
    description: "Evaluates the model's own validation rules and their exceptions; an error finding is fatal. From a base a rule bound as before is evaluated again only for the elements and chains the change touches, and its model-wide parts — acyclicity, the use of an exception — when something its selectors match changed."
    relations:
      - type: triggering
        target: derive

  derive:
    type: process
    name: Derive
    description: "Derives the relations the model implies, each by its shortest chain of stated relations, unless the model is already fatal. From a base it takes out every derived fact standing on what changed and derives again from what remains; past a bound on how much changed it derives whole."
    relations:
      - type: triggering
        target: check-views

  check-views:
    type: process
    name: Check views
    description: "Checks every view against the model and its derived relations, and resolves the styles that match only derived relations. From a base a view is checked again only when its file changed, an element it places changed, or a relation came or went between two elements it places."

  compiled-model:
    type: data-object
    name: Compiled model
    description: "What a compilation answers — the model, its findings, its derived relations, its bound rules and styles — with what a later compilation of the same model starts from: each file's unit with the id of its content, the manifest's id and the state each stage last computed. Immutable and shared between threads, and never what a read is answered from."
