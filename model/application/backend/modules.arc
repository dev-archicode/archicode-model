# The backend's modules: one build, several applications from it. An application aggregates the
# libraries it ships, and a library that depends on another is served by it, so the aggregations and
# the serving relations below are the build's module graph; a test dependency, which no application
# ships, is served too.
imports:
  - application.backend.compiler
  - application.edge
  - application.frontend
  - motivation
  - strategy
  - business
  - external
  - application.data

elements:
  common:
    type: application-component
    name: Common
    description: "The notation-agnostic metamodel, the notation metamodel that notation definitions are written against, and the port to a model's files — a directory, a commit, a draft laid over either."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: common
      technology: "Java 25"
    relations:
      - type: serving
        target: compiler
      - type: serving
        target: language
      - type: serving
        target: service-support
      - type: serving
        target: storage-git
      - type: serving
        target: storage-index
      - type: serving
        target: storage-model
      - type: serving
        target: merge
      - type: serving
        target: compare
      - type: realization
        target: motivation.minimal-metamodel
      - type: realization
        target: motivation.no-notation-in-the-core

  compiler:
    type: application-component
    name: Compiler
    description: "Turns model files into a resolved, validated and linted model, and answers on demand the relations it implies."
    tags: [compiler, core]
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: compiler
      technology: "Java 25, SnakeYAML, Jackson"
    relations:
      - type: aggregation
        target: application.backend.compiler.arc
      - type: aggregation
        target: application.backend.compiler.configuration
      - type: aggregation
        target: application.backend.compiler.context
      - type: aggregation
        target: application.backend.compiler.derivation
      - type: aggregation
        target: application.backend.compiler.diagnostic
      - type: aggregation
        target: application.backend.compiler.document
      - type: aggregation
        target: application.backend.compiler.draft
      - type: aggregation
        target: application.backend.compiler.graph
      - type: aggregation
        target: application.backend.compiler.json
      - type: aggregation
        target: application.backend.compiler.layout
      - type: aggregation
        target: application.backend.compiler.linter
      - type: aggregation
        target: application.backend.compiler.manifest
      - type: aggregation
        target: application.backend.compiler.notation
      - type: aggregation
        target: application.backend.compiler.pipeline
      - type: aggregation
        target: application.backend.compiler.position
      - type: aggregation
        target: application.backend.compiler.reader
      - type: aggregation
        target: application.backend.compiler.resolver
      - type: aggregation
        target: application.backend.compiler.rules
      - type: aggregation
        target: application.backend.compiler.schema
      - type: aggregation
        target: application.backend.compiler.selector
      - type: aggregation
        target: application.backend.compiler.style
      - type: aggregation
        target: application.backend.compiler.view
      - type: aggregation
        target: application.backend.compiler.yaml
      - type: serving
        target: storage-index
      - type: serving
        target: storage-model
      - type: serving
        target: service-support
      - type: serving
        target: compare
      - type: serving
        target: language
      - type: assignment
        target: application.backend.compiler.compile
      - type: realization
        target: motivation.one-model-three-surfaces
      - type: realization
        target: motivation.fr-m3
      - type: realization
        target: strategy.modeling-as-code

  language:
    type: application-component
    name: Language
    description: "The language features of the DSL over a model's files, with no transport and no framework, so that a hosted service and a local one embed it unchanged: the place at a cursor in text that does not parse, found from the indentation of its lines, and the symbols of a model — its packages, elements and junctions, and the configuration's declarations — read shallowly with the compiler's own readers."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: language
      technology: "Java 25"
    relations:
      - type: realization
        target: motivation.fr-m14

  merge:
    type: application-component
    name: Merge
    description: "Merging two versions of a file with no transport, no framework and no model: a text three ways, line by line, answered as segments agreed by both sides, by the head or by the draft, or contested with the three texts; and a view by structure, its nodes by id and its edges by identity, with the origin of each and the decisions left to the person. Two ways when the base is gone, every difference contested. A hosted service and a local one embed it unchanged."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: merge
      technology: "Java 25, JGit's diff"

  compare:
    type: application-component
    name: Compare
    description: "What one compiled model changes against another, from two compilation results held in memory and nothing read from a store: the elements, the declared relations and the views added, changed with the fields that differ, and removed; for a changed view its nodes added, removed, moved and changed and its edges added, removed and changed. A hosted service and a local one embed it unchanged."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: compare
      technology: "Java 25"

  storage-git:
    type: application-component
    name: Storage — Git
    description: "Git access through a bare clone: following a remote's default branch, writing a commit that adds, replaces and removes files and pushing it, and a model's files read from a commit. JGit stays inside it."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: storage-git
      technology: "Java 25, JGit"

  storage-index:
    type: application-component
    name: Storage — Index
    description: "The graph index: a model's compilation applied at a revision in one transaction, and the reads over it, in one graph partitioned by model, the declared relations alone. Rebuildable from the repository alone; it reads no git and compiles nothing. No deployment takes it: the model service walks the read model for impact, and only the MCP server, out of the build, uses the index, which goes when that server is unfrozen."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: storage-index
      technology: "Java 25, Neo4j embedded"
    relations:
      - type: access
        target: graph-index
        properties: { access-type: readwrite }

  storage-model:
    type: application-component
    name: Storage — Model
    description: "The read model: a model's files and what its compilation yields, the declared relations alone, written at a revision and never changed, the head's row and the lease that guards moving it, and the reads over them, in PostgreSQL. Derived from the repository; it reads no git and compiles nothing."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: storage-model
      technology: "Java 25, plain JDBC, PostgreSQL"
    relations:
      - type: serving
        target: service-support
      - type: access
        target: read-model
        properties: { access-type: readwrite }
      - type: realization
        target: motivation.nfr-p6

  read-model:
    type: data-object
    name: Read model
    description: "The files of each model at a revision and what compiling them yields — elements, declared relations, packages, views; no derived relation — with a head per model naming the revision every read is answered from. Derived and disposable."

  overlay:
    type: data-object
    name: Overlay
    description: "A person's draft files of a model, as the service holds them to lay over its head: each file's path, the id of the content it started from and its new content or that it is deleted, with what compiling them with the head found, the findings and the rows of the model files they change. Named by the SHA-256 of its files. A cache the service may lose; the draft is the browser's."

  graph-index:
    type: data-object
    name: Graph index
    description: "Elements, junctions, declared relations, properties and the view registry of each model, projected for the MCP server's search, impact and context queries. The MCP server's alone, embedded in its process; no deployment takes it. Derived and disposable."

  service-support:
    type: application-component
    name: Service support
    description: "What the two server applications wire the same way, written once: the resource server that trusts the gateway's token and the error body it answers a refused request with, the read model's pool and its settings, the clock, the keys of the log's context, and the bound on compilations. A library with Spring in it and no application of its own, which holds none of the product's logic: it takes the core's common, compiler and storage-model and no application, and the build checks it."
    properties:
      realization-status: develop
      module-kind: support-library
      repository: nkurgachev/archicode
      path: service-support
      technology: "Java 25, Spring Boot 4, Spring Security OAuth2 resource server, Spring JDBC"

  cli:
    type: application-component
    name: CLI
    description: "The command-line interface, for people and for CI: init, lint, validate, context. A prototype, out of the build until its development resumes."
    properties:
      realization-status: develop
      module-kind: application
      repository: nkurgachev/archicode
      path: cli
      technology: "Java 25, Spring Boot 4, picocli"
    relations:
      - type: aggregation
        target: common
      - type: aggregation
        target: compiler
      - type: aggregation
        target: storage-git
      - type: composition
        target: command-line

  command-line:
    type: application-interface
    name: archicode
    specialization: "command line"
    description: "The archicode command, run against a checkout on a person's machine or in CI. Unauthenticated: it trusts the filesystem and git access."
    properties:
      realization-status: develop
      protocol: "Process arguments, standard streams, exit code"
    relations:
      - type: serving
        target: business.edit-as-code
      - type: serving
        target: business.lint-in-ci

  mcp:
    type: application-component
    name: MCP server
    description: "The interface for AI agents: search, elements, relations, views, impact, context, lint and validation. Out of the build until its development resumes."
    properties:
      realization-status: develop
      module-kind: application
      repository: nkurgachev/archicode
      path: mcp
      technology: "Java 25, Spring Boot 4, Spring AI MCP server"
    relations:
      - type: aggregation
        target: common
      - type: aggregation
        target: compiler
      - type: aggregation
        target: storage-git
      - type: aggregation
        target: storage-index
      - type: composition
        target: mcp-tools
      - type: realization
        target: motivation.agents-read-people-write
      - type: realization
        target: motivation.fr-m9

  mcp-tools:
    type: application-interface
    name: MCP tools
    specialization: "json-rpc api"
    description: "search_elements, get_element, get_relations, get_view, get_impact, get_context, lint_model, validate_model."
    properties:
      realization-status: develop
      protocol: "MCP, JSON-RPC 2.0 over stdio"
    relations:
      - type: serving
        target: external.ai-agent
      - type: serving
        target: business.read-the-context

  model-service:
    type: application-component
    name: Model service
    description: "The model side behind the gateway: the web application's APIs over a model, the one writer to each model repository, and the product store's first owner. Writes the head of each branch it fetches into the read model and answers every read from there, of the branch the read names, from no compiled model, so any number of instances run side by side; each holds the compiled models of the heads it works on, the base of its next compilations, so that a commit costs what it changes. Holds a person's draft as overlays in Redis, which every instance shares, with the rows of the model files the draft changes, read in place of the head's, so that an element made or edited in the draft is seen before it is promoted. Stores no derived relation, neither in the read model nor in an overlay: a read that needs them asks a derivation session over the read model's declared relations, the draft's overlay laid over each wave. Knows no kind of git host."
    properties:
      realization-status: develop
      module-kind: application
      repository: nkurgachev/archicode
      path: model-service
      technology: "Java 25, Spring Boot 4, Spring MVC on virtual threads, JPA, Flyway, Spring Data Redis"
    relations:
      - type: aggregation
        target: common
      - type: aggregation
        target: compare
      - type: aggregation
        target: compiler
      - type: aggregation
        target: git-host
      - type: aggregation
        target: git-host-github
      - type: aggregation
        target: merge
      - type: aggregation
        target: service-support
      - type: aggregation
        target: storage-git
      - type: aggregation
        target: storage-model
      - type: composition
        target: models-api
      - type: composition
        target: canvas-api
      - type: composition
        target: files-api
      - type: composition
        target: branches-api
      - type: composition
        target: configuration-api
      - type: composition
        target: model-setup-api
      - type: composition
        target: live-api
      - type: access
        target: linked-credential
        properties: { access-type: readwrite }
      - type: access
        target: overlay
        properties: { access-type: readwrite }
      - type: access
        target: application.backend.compiler.compiled-model
        description: "Holds the compiled models of the heads it brought in or compiled over, by model and revision, bounded by their estimated weight with the least recently used going first: a branch's new head is compiled from its previous head's, else the default's, else from all the files, and a draft's check, a refactor, a compare and an update from the head's. A draft's compilation is never held."
        properties: { access-type: readwrite }
      - type: realization
        target: motivation.fr-a3
      - type: realization
        target: strategy.impact-analysis
      - type: access
        target: application.data.view-document
        properties: { access-type: readwrite }
      - type: serving
        target: business.commit-the-change

  models-api:
    type: application-interface
    name: Models API
    specialization: "rest api"
    description: "The models the person can read, on every git host they linked; one model's summary — its counts and top-level packages, read at the head — and the recent history of its branch."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: /api/v1/models
    relations:
      - type: serving
        target: application.edge.gateway
        name: Models API requests
        specialization: http
      - type: realization
        target: motivation.fr-a8

  canvas-api:
    type: application-interface
    name: Canvas API
    specialization: "rest api"
    description: "The notation, with the look and the size the model's styles give each element type, the package tree, search, the palette, views with resolved styles, their descriptions and the last change of each view's file, a draft's view document resolved at the head, an element with its relations, the elements a change to an element reaches or that it depends on, at any depth over declared and derived relations through junctions, a relation's own fields and the file that declares it, and the relation types the notation allows for a pair of elements; and, answering the files for the draft, a patch of an element's own fields, a new element or junction, a new relation, a patch of a relation's own fields, and the refactors — rename, move and delete of an element, delete of a relation and a relation's new type — with a preview of what they touch. Every read takes an overlay, the id of a person's draft to read the model with, and answers the draft's own elements."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: "/api/v1/canvas/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: Canvas API requests
        specialization: http

  files-api:
    type: application-interface
    name: Files API
    specialization: "rest api"
    description: "A model's files and the content of one, by path or by the id of a content; an overlay — a person's draft files, held for the reads that name it, with what the model comes to with them; and promote — the files of a draft written as one commit on the branch the person names, the default when none, pushed with the person's own credential, or, where it names the default to bring in, the branch's update from it as one merge commit with two parents; and merge — a stale file of a draft merged with the head's, or a file of a branch merged with the default's, a text line by line and a view by structure, answering what both sides agree on and what the person decides."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: "/api/v1/files/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: Files API requests
        specialization: http
      - type: serving
        target: language-service
        name: Files API requests
        description: "Once per session, with the person's token: whether the person may read the model, and the head brought in if the read model has none"
        specialization: http

  branches-api:
    type: application-interface
    name: Branches API
    specialization: "rest api"
    description: "The branches of a model's repository as the service last fetched them, with how far each has gone from the default; a branch made from the head of another and a branch deleted, both pushed to the host with the person's own credential. What a branch changes against the default, compared as models; the default brought into a branch, merged file by file with the contested files left to the person; and the branch's pull request on the host — opened, read with its conversation, replied to, resolved, reviewed and merged, with the person's own credential."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: "/api/v1/branches/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: Branches API requests
        specialization: http

  live-api:
    type: application-interface
    name: Live API
    specialization: "websocket api"
    description: "The live channel of an open model: a WebSocket that pushes the head's revision whenever the head moves and the list of who is on which view and in which file, each person's place sent by the client and kept in memory only. A signal, never a lock and never state."
    properties:
      realization-status: develop
      protocol: WebSocket
      endpoint: "/api/v1/live/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: Live channel
        specialization: websocket

  configuration-api:
    type: application-interface
    name: Configuration API
    specialization: "rest api"
    description: "A model's manifest and configuration documents read as files, each by its kind's shape with its declarations, its problems and where each declaration is used; the vocabulary the forms offer, from the notation and the product's own tables; the findings of the model as it is; and a patch that changes a document by place, answering the texts. The reads take an overlay; the patch reads no model and writes nothing."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: "/api/v1/configuration/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: Configuration API requests
        specialization: http

  model-setup-api:
    type: application-interface
    name: Model setup API
    specialization: "rest api"
    description: "Linking a git token for a host and an owner, replacing and unlinking it, hiding a model, a model's settings, connecting one by link, after a check that names the model a repository is already — initialising an empty repository as the person — and removing one."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: "/api/v1/git-accounts, /api/v1/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: Model setup API requests
        specialization: http

  git-host:
    type: application-component
    name: Git host port
    description: "What the model service speaks to git hosts in: a repository's address on a host, the settings an adapter is made from, and the capabilities an adapter for a kind of host may offer."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: git-host
      technology: "Java 25"
    relations:
      - type: serving
        target: git-host-github

  git-host-github:
    type: application-component
    name: GitHub adapter
    description: "What only GitHub's API can say — whose a token is and when it expires, what an account may do with a repository and which branch is its default, and the pull requests of a model's branches with their conversation, review threads and reviews, read through the REST and GraphQL APIs and written through them — for github.com and GitHub Enterprise Server. The model service takes it at run time only."
    properties:
      realization-status: develop
      module-kind: core
      repository: nkurgachev/archicode
      path: git-host-github
      technology: "Java 25, the JDK's HTTP client, Jackson, GraphQL"

  linked-credential:
    type: data-object
    name: Linked credential
    description: "A person's personal access token on a git host, kept encrypted and never shown again. Every write to a model is pushed with it."
    visibility: private

  language-service:
    type: application-component
    name: Language service
    description: "Editor assistance over the DSL for the web code mode: a service of its own, since it holds a session per open editor and its load is CPU. A session is one WebSocket the gateway routes, speaking the Language Server Protocol, whose token is checked at the handshake. The head of a model is read from the read model into a snapshot the sessions of the model share, which holds the head's compiled model, and a person's draft is the documents the session holds open, compiled from it once the typing pauses; the one call it makes to the model service asks whether the person may read the model."
    properties:
      realization-status: develop
      module-kind: application
      repository: nkurgachev/archicode
      path: language-service
      technology: "Java 25, Spring Boot 4, Spring MVC on virtual threads, Spring WebSocket, LSP4J"
    relations:
      - type: aggregation
        target: common
      - type: aggregation
        target: compiler
      - type: aggregation
        target: language
      - type: aggregation
        target: service-support
      - type: aggregation
        target: storage-model
      - type: composition
        target: language-api
      - type: access
        target: application.backend.compiler.compiled-model
        description: "Each snapshot of a model's head holds the head's compiled model, made once — from the replaced snapshot's within one model and branch — and every session's compilation of its open documents starts from it once the typing pauses."
        properties: { access-type: readwrite }
      - type: realization
        target: motivation.fr-m14

  language-api:
    type: application-interface
    name: Language API
    specialization: "websocket api"
    description: "The code editor's language-server session: the Language Server Protocol over a WebSocket, one JSON-RPC message to a text frame, with the draft as the documents the session holds open. A session is opened at one branch of the model, the default when none is named. Routed through the gateway."
    properties:
      realization-status: develop
      protocol: WebSocket
      endpoint: "/api/v1/language/models/{model}"
    relations:
      - type: serving
        target: application.edge.gateway
        name: LSP
        specialization: websocket

  examples:
    type: application-component
    name: Examples
    description: "The reference models — an ArchiMate one made from this model as it stood on 2026-10-23, and a C4 one — that the tests compile and the web's acceptance runs, published for it as repositories it resets before every run; test models, never shipped. This model lives in a repository of its own, changed with ArchiCode and by pull requests."
    properties:
      realization-status: develop
      module-kind: reference-model
      repository: nkurgachev/archicode
      path: examples

  openapi:
    type: application-component
    name: OpenAPI documents
    description: "The web API's shapes as OpenAPI documents, one per area and one for the session: generated in the tests of the service that answers each, compared with these by the build, edited by nobody and never served. The web application's API types are generated from them."
    properties:
      realization-status: develop
      module-kind: documents
      repository: nkurgachev/archicode
      path: openapi
    relations:
      - type: flow
        target: application.frontend.api-types

  openapi-testing:
    type: application-component
    name: OpenAPI testing
    description: "What the tests of the services that generate the OpenAPI documents share: completing springdoc's reading of the controllers, comparing a document with the one held, holding every error answer to the codes its operation declares, and checking that no path under /api goes without a document. A test dependency only: no deployment runs any of it."
    properties:
      realization-status: develop
      module-kind: test-support
      repository: nkurgachev/archicode
      path: openapi-testing
      technology: "Java 25, springdoc-openapi"
    relations:
      - type: serving
        target: model-service
      - type: serving
        target: application.edge.gateway
