# The hosted product: one customer, one deployment, one Helm chart on the customer's own
# Kubernetes cluster. The browser reaches it on one origin through one ingress.
imports:
  - application.backend
  - application.edge
  - application.frontend
  - motivation

elements:
  kubernetes:
    type: node
    name: Kubernetes cluster
    description: "The customer's own cluster. There is no shared instance and no tenant to isolate."
    properties:
      realization-status: planned
    relations:
      - type: composition
        target: ingress
      - type: aggregation
        target: gateway-node
      - type: aggregation
        target: model-service-node
      - type: aggregation
        target: language-server-node
      - type: aggregation
        target: web-node
      - type: aggregation
        target: redis
      - type: aggregation
        target: postgresql
      - type: assignment
        target: archicode-chart

  archicode-chart:
    type: artifact
    name: archicode Helm chart
    description: "The one thing a customer installs: every backend service, the gateway, the frontend container and the stores, released together at one version."
    properties:
      realization-status: planned
    relations:
      - type: realization
        target: motivation.one-customer-one-deployment
      - type: realization
        target: motivation.nfr-c4

  ingress:
    type: technology-interface
    name: Ingress
    description: "One origin for the browser, so that the session cookie flows: /api to the gateway, everything else to the web container."
    properties:
      realization-status: planned
      protocol: HTTPS
      port: 443
    relations:
      - type: serving
        target: application.frontend.web-application
      - type: serving
        target: application.edge.gateway

  gateway-node:
    type: node
    name: Gateway
    description: "The authentication gateway's pods. Its sessions live in Redis, so every replica serves every session."
    properties:
      realization-status: develop
      technology: "Java 25"
    relations:
      - type: assignment
        target: gateway-jar
      - type: composition
        target: gateway-port
      - type: composition
        target: gateway-management-port

  gateway-jar:
    type: artifact
    name: gateway.jar
    properties:
      realization-status: develop
      path: gateway/build/libs/gateway-0.1.0-SNAPSHOT.jar
    relations:
      - type: realization
        target: application.edge.gateway

  gateway-port:
    type: technology-interface
    name: Gateway main port
    description: "The browser's requests, from the ingress, and the public keys the services fetch."
    properties:
      realization-status: develop
      protocol: HTTP
      port: 8080

  gateway-management-port:
    type: technology-interface
    name: Gateway management port
    description: "Health, loggers, metrics and Prometheus, for the cluster and its monitoring. Never routed from the ingress."
    properties:
      realization-status: develop
      protocol: HTTP
      port: 8081

  redis:
    type: system-software
    name: Redis
    specialization: "data store"
    description: "The gateway's sessions and their tokens, the authorization request between the sign-in flow's two legs, and the lock that serialises a refresh, and the model service's overlays under keys of their own, the files of its collaborative sessions, the pull requests it keeps for every instance of it, and its live channel's pub/sub, which carries a branch's head move, or its disappearance, and the list of who is where on which branch between instances. A session survives a restart of the gateway; an overlay and a session's files are a cache the client sends again; what the host said of pull requests is a cache the host is asked for again; a message of the channel is a signal that may be lost."
    properties:
      realization-status: develop
      version: "8.10"
      disposable: false
    relations:
      - type: serving
        target: application.edge.gateway
        name: Sessions
        specialization: redis
      - type: serving
        target: application.backend.model-service
        name: Overlays
        specialization: redis
      - type: assignment
        target: overlay-store

  overlay-store:
    type: artifact
    name: Overlay store
    description: "The overlays of drafts in Redis, under keys with a prefix of the model service's own: each a person's files of a model with the check of them, kept for the person and the model, the four a person named most recently, and dropped an hour after nobody named it. A collaborative session's overlays are in it as well, the four latest of a session, beside the files and contents of the session itself under a prefix of their own. Every instance of the service shares it. Losing it loses nothing: the client sends an overlay again, and the keeper sends a session's files again."
    properties:
      realization-status: develop
      disposable: true
    relations:
      - type: realization
        target: application.backend.overlay
      - type: realization
        target: application.backend.session
      - type: realization
        target: motivation.stores-are-disposable

  model-service-node:
    type: node
    name: Model service
    description: "The one writer to each model repository: it keeps a clone of each model to fetch and push with, compiles each head it fetches and writes it into the read model, and answers every read from there; a person's draft is held beside it as overlays in Redis. It answers no read from a compiled model — what it holds of the heads it works on is only the base of its next compilations —, so as many instances as the load asks for run side by side."
    properties:
      realization-status: develop
      technology: "Java 25"
    relations:
      - type: assignment
        target: model-service-jar
      - type: assignment
        target: bare-clones
      - type: composition
        target: model-service-port
      - type: composition
        target: model-service-management-port

  model-service-port:
    type: technology-interface
    name: Model service main port
    description: "The requests the gateway routes to the model side's areas, each with the token the gateway signed."
    properties:
      realization-status: develop
      protocol: HTTP
      port: 8080

  model-service-management-port:
    type: technology-interface
    name: Model service management port
    description: "Health, metrics and Prometheus, for the cluster and its monitoring, without a token. Never routed from the ingress; every other path is denied."
    properties:
      realization-status: develop
      protocol: HTTP
      port: 8081

  model-service-jar:
    type: artifact
    name: Model service jar
    properties:
      realization-status: develop
      path: model-service/build/libs/model-service-0.1.0-SNAPSHOT.jar
    relations:
      - type: realization
        target: application.backend.model-service

  bare-clones:
    type: artifact
    name: Bare clones
    description: "A bare clone of each model, without a working tree, fetched with the deployment's read-only service credential. A cache: it may live on a volume that does not survive a restart."
    properties:
      realization-status: develop
      disposable: true
    relations:
      - type: realization
        target: motivation.stores-are-disposable

  postgresql:
    type: system-software
    name: PostgreSQL
    specialization: "data store"
    description: "One cluster, two databases. The product store: accounts, linked credentials, hidden models, audit, the record of each collaborative session; never architecture, and not rebuildable from anything. The read model's database stands beside it, apart."
    properties:
      realization-status: develop
      version: "18.6"
      disposable: false
    relations:
      - type: serving
        target: application.backend.model-service
        name: SQL
        specialization: jdbc
      - type: serving
        target: application.backend.language-service
        name: SQL
        description: "Reading only: the head's row, every few seconds, and a revision's files, once for a model and revision"
        specialization: jdbc
      - type: assignment
        target: read-model-database
      - type: realization
        target: motivation.product-data-apart

  read-model-database:
    type: artifact
    name: Read model database
    description: "A database of the PostgreSQL cluster beside the product store's, with credentials of its own, that the model service writes and reads: a revision of every model, derived from the repositories. Dropping it loses nothing; the service writes each model again at its next follow."
    properties:
      realization-status: develop
      disposable: true
    relations:
      - type: realization
        target: application.backend.read-model
      - type: realization
        target: motivation.stores-are-disposable
      - type: realization
        target: motivation.product-data-apart

  language-server-node:
    type: node
    name: Language server
    description: "A service of its own, scaled apart from the model service: it holds a session per open editor and its load is CPU."
    properties:
      realization-status: planned
      technology: "Java 25"

  web-node:
    type: node
    name: Web container
    description: "Serves the web application's static tree. There is no container image yet."
    properties:
      realization-status: planned
    relations:
      - type: assignment
        target: web-bundle
      - type: composition
        target: static-web-server

  static-web-server:
    type: system-software
    name: Static web server
    description: "SPA fallback for the shell, no-store for every mf-manifest.json so that no remote is pinned to an old release, and long-lived caching for hashed chunks."
    properties:
      realization-status: planned

  web-bundle:
    type: artifact
    name: Web static tree
    description: "What npm run build assembles: the shell at the root and each remote under /remotes/<dir>/."
    properties:
      realization-status: develop
      path: dist
    relations:
      - type: realization
        target: application.frontend.web-application
