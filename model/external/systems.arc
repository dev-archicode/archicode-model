# The systems ArchiCode relies on and owns none of. Each is the customer's.
imports:
  - application.backend
  - application.edge
  - business
  - motivation

elements:
  git-host:
    type: application-component
    name: Git host
    description: "Where the customer keeps model repositories — GitLab, Bitbucket, GitHub Enterprise and others. The single source of truth, and the one that decides who may read or write a model."
    properties:
      realization-status: production
    relations:
      - type: serving
        target: application.backend.model-service
        id: fetch
        name: git fetch
        description: "Fetches each model into a bare clone, with the deployment's read-only service credential"
        specialization: https
      - type: serving
        target: application.backend.model-service
        id: push
        name: git push
        description: "Accepts a promote's commit, pushed with the person's own linked credential"
        specialization: https
      - type: serving
        target: application.backend.git-host-github
        name: REST and GraphQL APIs
        description: "Says, through its REST and GraphQL APIs, whose a token is, when it expires and what an account may do with a repository, and holds the pull requests of a model's branches with their conversation and reviews"
        specialization: https
      - type: realization
        target: motivation.git-is-the-source-of-truth

  identity-provider:
    type: application-component
    name: Identity provider
    description: "The customer's OIDC provider — Keycloak, Okta, Entra ID. The gateway is its confidential client."
    properties:
      realization-status: production
    relations:
      - type: serving
        target: application.edge.gateway
        name: OIDC
        description: "Signs the person in, and refreshes the session's tokens"
        specialization: https

  jira:
    type: application-component
    name: Jira
    description: "The customer's issue tracker, read on demand to show a ticket a model refers to. Never a source of architecture."
    properties:
      realization-status: production
    relations:
      - type: serving
        target: application.backend.model-service
        description: "Resolves a ticket reference for display"
        properties: { realization-status: develop }
      - type: realization
        target: motivation.integrations-enrich

  ai-agent:
    type: application-component
    name: AI agent
    description: "An agent a person starts — Claude Code, Copilot, Cursor — reading the model over MCP."
    properties:
      realization-status: production
    relations:
      - type: assignment
        target: business.ai-agent
