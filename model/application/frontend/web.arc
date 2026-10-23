# The web application: a shell and a Module Federation remote per functional area, served
# as one static tree on one origin. It reaches the backend only through the gateway.
imports:
  - motivation
  - strategy
  - business

elements:
  web-application:
    type: application-component
    name: Web application
    description: "The browser surface: visualization and editing of a model, and its setup. The shell loads each remote on the first navigation into it."
    properties:
      realization-status: develop
      repository: nkurgachev/archicode-web
      technology: "TypeScript 6, React 19, Rsbuild 2, Module Federation 2, Mantine"
    relations:
      - type: aggregation
        target: shell
      - type: aggregation
        target: canvas
      - type: aggregation
        target: configuration
      - type: aggregation
        target: code
      - type: aggregation
        target: model-setup
      - type: aggregation
        target: settings
      - type: aggregation
        target: review
      - type: aggregation
        target: platform
      - type: aggregation
        target: ui
      - type: aggregation
        target: diagram
      - type: aggregation
        target: api-types
      - type: composition
        target: web-ui

  web-ui:
    type: application-interface
    name: Web UI
    description: "The pages a person works in: those about one model under /models/{modelId}/…, the list of every model and connecting one under /all-models, the person's own settings under /settings."
    properties:
      realization-status: develop
      protocol: HTTPS
      endpoint: "/models/{modelId}/, /all-models, /settings"
    relations:
      - type: serving
        target: business.architect

  shell:
    type: application-component
    name: Shell
    description: "The layout, the navigation, the mounts and the sections as data; mounts a remote's routes on the first navigation into each of its paths, and keeps working when one does not load."
    properties:
      realization-status: develop
      module-kind: shell
      repository: nkurgachev/archicode-web
      path: apps/shell

  canvas:
    type: application-component
    name: Canvas
    description: "Opens a model's views, lays them out and composes them; keeps the changes in a draft per model and branch and promotes the draft to one commit."
    properties:
      realization-status: develop
      module-kind: remote
      repository: nkurgachev/archicode-web
      path: apps/canvas
      technology: "React Flow, ELK, Zustand"
    relations:
      - type: serving
        target: shell
      - type: realization
        target: motivation.draft-then-promote
      - type: realization
        target: motivation.fr-v4
      - type: realization
        target: strategy.visualization
      - type: serving
        target: business.edit-on-canvas

  configuration:
    type: application-component
    name: Configuration
    description: "A model's manifest and its five kinds of configuration document — enum dictionaries, property declarations, specializations, validation rules with the tuning of the built-in checks, stylesheets — edited as forms and shown as files, with where each declaration is used and the findings of the model with the draft laid over it. Every change is a file of the draft; the page has no promote of its own."
    properties:
      realization-status: develop
      module-kind: remote
      repository: nkurgachev/archicode-web
      path: apps/configuration
      technology: "React Flow, through the diagram package, for the stylesheets' preview"
    relations:
      - type: serving
        target: shell
      - type: access
        target: draft
        properties: { access-type: readwrite }

  code:
    type: application-component
    name: Code
    description: "The Model page: the editor of a model's files — the packages' files, the manifest and the configuration documents — on CodeMirror, with the language session over the gateway's WebSocket for completion, hover, definition and the model's findings as the person types, and the files area for the model's files. Every change is a file of the draft; the page has no promote of its own."
    properties:
      realization-status: develop
      module-kind: remote
      repository: nkurgachev/archicode-web
      path: apps/code
      technology: "CodeMirror 6, its language-server client"
    relations:
      - type: serving
        target: shell
      - type: access
        target: draft
        properties: { access-type: readwrite }
      - type: realization
        target: motivation.fr-m14

  draft:
    type: data-object
    name: Draft
    description: "What a person has changed in one model and has not promoted yet, whichever area wrote it: a set of files, each with the id of the content it was read as and its whole new text or that it is deleted. One per person, model and branch, held by the platform in the browser's IndexedDB, with a copy in memory; the service sees it as an overlay and takes it as one promote."

  model-setup:
    type: application-component
    name: Model setup
    description: "The list of models a person can read, hiding one, a model's settings, connecting one by link and removing one. Mounted twice: at /all-models, and at /models/{modelId}/settings for one model."
    properties:
      realization-status: develop
      module-kind: remote
      repository: nkurgachev/archicode-web
      path: apps/model-setup
    relations:
      - type: serving
        target: shell
      - type: realization
        target: motivation.fr-a3

  settings:
    type: application-component
    name: Settings
    description: "A person's own settings, reached from the account menu: the git accounts they link on the deployment's hosts, a token checked before it is linked and warned of before it expires."
    properties:
      realization-status: develop
      module-kind: remote
      repository: nkurgachev/archicode-web
      path: apps/settings
    relations:
      - type: serving
        target: shell
      - type: realization
        target: motivation.fr-a3

  review:
    type: application-component
    name: Review
    description: "The pull requests: the list of the open ones, mounted at /models/{modelId}/pulls and reached from Modeling's sidebar after Overview, and a request's page at /models/{modelId}/pulls/{number}, in two tabs. Conversation holds the description, the reviews given, and the comments and threads on the request and on its files, written to the host; Changes holds the compare of the branch with the one it targets, in Model — the views drawn on the canvas with a mark on each change, the elements and the relations — and in Text — the files with their threads. From the page a person gives a review, updates the branch from the default and merges. Reads the branches, canvas and files areas; writes the conversation and the review to the branches area and the update to the files area, an update with files to decide continuing in the draft."
    properties:
      realization-status: develop
      module-kind: remote
      repository: nkurgachev/archicode-web
      path: apps/review
      technology: "React Flow, through the diagram package, for the views of the compare"
    relations:
      - type: serving
        target: shell

  platform:
    type: application-component
    name: Platform
    description: "The contract between the shell and the remotes: the API client, the session and its gate, the model the URL names and the branch it names in ?branch=, the model list, the model and account menus, the update of a branch from the default — its dialog and the update in progress, kept beside the draft —, the table of the mounts' addresses, the theme. Its main entry is shared as a single instance at runtime; what an entry point and the shell alone use is bundled into each application."
    properties:
      realization-status: develop
      module-kind: package
      repository: nkurgachev/archicode-web
      path: packages/platform
    relations:
      - type: serving
        target: shell
      - type: serving
        target: canvas
      - type: serving
        target: configuration
      - type: serving
        target: code
      - type: serving
        target: model-setup
      - type: serving
        target: settings
      - type: serving
        target: review
      - type: access
        target: draft
        properties: { access-type: readwrite }
      - type: realization
        target: motivation.fr-a8

  diagram:
    type: application-component
    name: Diagram
    description: "The drawing of a view: the view document and its index and geometry, React Flow's nodes and edges, the shapes, icons, line ends and labels, and a read-only diagram of a view's answer. Shared by the canvas, which edits over it, the configuration's preview of a stylesheet and the review's views with the marks of a change. Bundled into each application that uses it, never shared at runtime."
    properties:
      realization-status: develop
      module-kind: package
      repository: nkurgachev/archicode-web
      path: packages/diagram
      technology: "React Flow"
    relations:
      - type: serving
        target: canvas
      - type: serving
        target: configuration
      - type: serving
        target: review

  ui:
    type: application-component
    name: UI
    description: "The presentation more than one application draws: stateless components over Mantine and the helpers they stand on. Bundled into each application that uses it, never shared at runtime; it imports neither the platform nor an application."
    properties:
      realization-status: develop
      module-kind: package
      repository: nkurgachev/archicode-web
      path: packages/ui
    relations:
      - type: serving
        target: platform
      - type: serving
        target: shell
      - type: serving
        target: model-setup
      - type: serving
        target: settings
      - type: serving
        target: canvas
      - type: serving
        target: review

  api-types:
    type: application-component
    name: API types
    description: "The web API's types, generated by a command of the web repository from the OpenAPI documents the backend generates, and held to them by its check. Types alone, bundled nowhere; every workspace that reads an answer imports it, and it imports none."
    properties:
      realization-status: develop
      module-kind: package
      repository: nkurgachev/archicode-web
      path: packages/api-types
    relations:
      - type: serving
        target: platform
      - type: serving
        target: model-setup
      - type: serving
        target: settings
      - type: serving
        target: review
