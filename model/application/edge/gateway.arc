# The authentication gateway, at the edge of the web application. It is the only server the
# browser talks to, and it depends on no other module at run time: only its tests take one.
imports:
  - application.backend
  - application.frontend

elements:
  gateway:
    type: application-component
    name: Authentication gateway
    description: "The edge of the web application: sign-in and the browser session, and routing every other API request to the service that serves it, with a token of its own for the person."
    properties:
      realization-status: develop
      module-kind: application
      repository: nkurgachev/archicode
      path: gateway
      technology: "Java 25, Spring Boot 4, Spring Cloud Gateway"
    relations:
      - type: composition
        target: session-api
      - type: composition
        target: api-routing
      - type: composition
        target: jwks
      - type: access
        target: browser-session
        properties: { access-type: readwrite }

  session-api:
    type: application-interface
    name: Session API
    specialization: "rest api"
    description: "Sign-in, sign-out and the session check, answered by the gateway itself."
    properties:
      realization-status: develop
      protocol: HTTPS
      endpoint: /api/session
    relations:
      - type: serving
        target: application.frontend.platform
        name: Session
        specialization: https

  api-routing:
    type: application-interface
    name: API routes
    specialization: "rest api"
    description: "Every other request under /api, routed by its /api/v<n>/<area>/ prefix to the service that serves the area, without the cookie and with a token the gateway signs. The language area's route is a WebSocket: the gateway upgrades the request to the language service and puts the same token on the upgrade."
    properties:
      realization-status: develop
      protocol: HTTPS
      endpoint: /api/v<n>/<area>/
    relations:
      - type: serving
        target: application.frontend.platform
        name: API requests
        specialization: https

  jwks:
    type: application-interface
    name: Public keys
    specialization: "rest api"
    description: "The gateway's public keys, a JWK set, for the services behind it to validate the tokens it signs."
    properties:
      realization-status: develop
      protocol: HTTP
      endpoint: /.well-known/jwks.json
    relations:
      - type: serving
        target: application.backend.model-service
        name: Public keys
        specialization: http
      - type: serving
        target: application.backend.language-service
        name: Public keys
        specialization: http

  browser-session:
    type: data-object
    name: Browser session
    description: "One per signed-in person: the provider's tokens and the person's identity claims, behind an opaque cookie. Product data, never part of a model."
    visibility: private
