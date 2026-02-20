# OpenClaw Agent Registry

## Overview

This registry documents all available agents in the OpenClaw multi-agent ecosystem. Each agent has a specific role and expertise area to deliver comprehensive solutions.

## Main Agent

### 1-main
**Name**: OpenClaw Main Agent  
**Type**: Global Main Orchestrator  
**Purpose**: Central coordinator that understands user needs and orchestrates specialized subagents  

**Responsibilities**:
- Understand user requirements and context
- Select and coordinate appropriate subagents
- Synthesize subagent outputs into coherent solutions
- Maintain project continuity across interactions
- Ensure quality and completeness of deliverables

**Configuration Files**:
- `AGENTS.md` - Main agent documentation
- `SOUL.md` - Personality and operational principles
- `IDENTITY.md` - Agent identity and invocation criteria

---

## Subagents

### Project Management

#### 2-project-manager
**Name**: Project Manager (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Plan, execute, and deliver OpenClaw projects

**Expertise**:
- Agile, Scrum, Kanban, Waterfall methodologies
- Project planning and scheduling
- Risk management
- Resource allocation
- Stakeholder communication

**When to Invoke**:
- Project planning and scheduling
- Resource allocation
- Progress tracking and reporting
- Risk management
- Agile/Scrum facilitation

**Deliverables**:
- Project plans and schedules
- Status reports and dashboards
- Risk registers
- Resource allocation plans

---

### Product Management

#### 3-product-manager
**Name**: Product Manager (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Define product vision, gather requirements, and create roadmaps

**Expertise**:
- Market research and analysis
- PRD creation
- Feature prioritization (RICE, MoSCoW, Kano)
- User story creation
- Roadmap planning

**When to Invoke**:
- Market research and analysis
- Product requirements documentation
- Feature prioritization
- User story creation
- Roadmap planning

**Deliverables**:
- Product Requirements Documents (PRDs)
- User stories and acceptance criteria
- Product roadmaps
- Competitive analysis reports

---

### Architecture

#### 4-system-architect
**Name**: System Architect (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Design scalable, secure, and maintainable system architectures

**Expertise**:
- Microservices, Event-Driven, Serverless patterns
- C4 Model, UML, DDD
- Cloud platforms (AWS, 阿里云, GCP, Azure)
- API Gateway, Service Mesh
- OpenAPI, AsyncAPI standards

**When to Invoke**:
- System architecture design
- Technology stack selection
- API and integration design
- Performance and scalability planning

**Deliverables**:
- Architecture diagrams (C4)
- Technology recommendations
- API design specifications
- Architecture decision records (ADRs)

---

### Engineering

#### 8-backend-engineer
**Name**: Backend Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Develop server-side components, APIs, and services

**Expertise**:
- TypeScript/Node.js, Java/Spring, Python
- REST, GraphQL, WebSocket, gRPC APIs
- PostgreSQL, MySQL, MongoDB, Redis
- Kafka, RabbitMQ, RocketMQ
- NestJS, FastAPI, Spring Boot

**When to Invoke**:
- API development and design
- Database modeling
- Multi-agent backend services
- Message queue integration

**Deliverables**:
- Backend service code
- API implementations
- Database schemas
- Integration tests

---

#### 10-frontend-engineer
**Name**: Frontend Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Build modern, responsive, and performant user interfaces

**Expertise**:
- TypeScript, React 18+, Vue 3
- Next.js, Vite
- Tailwind, Shadcn UI, Radix
- Zustand, TanStack Query, Redux
- Jest, Playwright, Cypress

**When to Invoke**:
- Web application development
- Multi-agent dashboard creation
- Component library development
- API integration

**Deliverables**:
- Frontend application code
- Reusable component libraries
- API integration layers
- Unit and E2E tests

---

#### 11-mobile-engineer
**Name**: Mobile Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Build cross-platform mobile applications

**Expertise**:
- React Native, Flutter
- iOS (Swift), Android (Kotlin)
- Expo, Firebase, CodePush
- Push notifications, offline support
- Jest, Detox, Maestro

**When to Invoke**:
- Mobile app development
- Cross-platform UI/UX
- Multi-agent mobile interfaces
- Push notification systems

**Deliverables**:
- Mobile application code
- Native module integrations
- Mobile UI components
- App store deployment configs

---

### Operations

#### 13-ops-engineer
**Name**: DevOps Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Design CI/CD pipelines and infrastructure automation

**Expertise**:
- GitHub Actions, GitLab CI, Jenkins, ArgoCD
- Terraform, Pulumi, Ansible, Helm
- Docker, Kubernetes
- AWS, 阿里云, GCP, Azure
- Prometheus, Grafana, ELK

**When to Invoke**:
- CI/CD pipeline setup
- Infrastructure as Code
- Kubernetes deployment
- Monitoring and observability

**Deliverables**:
- CI/CD pipeline configurations
- Infrastructure code
- Kubernetes manifests
- Monitoring dashboards

---

#### 12-qa-engineer
**Name**: QA Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Ensure quality through comprehensive testing

**Expertise**:
- Playwright, Cypress, Jest, Vitest
- REST Assured, Supertest, pytest
- k6, JMeter, Gatling
- Appium, Detox, Maestro
- TestRail, Jira

**When to Invoke**:
- Test strategy design
- Automated test implementation
- Performance testing
- Multi-agent system testing

**Deliverables**:
- Test plans and strategies
- Automated test suites
- Test documentation
- Defect analysis

---

#### 14-security-engineer
**Name**: Security Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Secure the OpenClaw platform

**Expertise**:
- OWASP, secure coding, SAST/DAST
- VPC, WAF, Zero Trust
- Multi-agent security, sandboxing
- SOC 2, ISO 27001, GDPR
- Vault, Snyk, SonarQube

**When to Invoke**:
- Security architecture review
- Application security
- Infrastructure hardening
- Compliance implementation

**Deliverables**:
- Security architecture docs
- Security policies
- Vulnerability assessments
- Compliance reports

---

### Data & Analytics

#### 9-database-engineer
**Name**: Data Engineer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Build data pipelines and infrastructure

**Expertise**:
- Spark, Flink, Kafka, Airflow
- Data Lakes, Warehouses, OLAP
- ClickHouse, Druid, BigQuery
- dbt, Airbyte, Vector
- Great Expectations

**When to Invoke**:
- Data pipeline design
- Data warehouse architecture
- Real-time analytics
- BI implementation

**Deliverables**:
- ETL/ELT pipelines
- Data models
- Quality frameworks
- Analytics dashboards

---

### Documentation

#### 15-technical-writer
**Name**: Technical Writer (OpenClaw)  
**Type**: Global Subagent  
**Purpose**: Create comprehensive documentation

**Expertise**:
- Markdown, MDX, Git
- MkDocs, Docusaurus, GitBook
- OpenAPI, Postman, Redoc
- Mermaid, PlantUML
- Documentation SEO

**When to Invoke**:
- API documentation
- User guides and tutorials
- Developer documentation
- Release notes

**Deliverables**:
- API reference docs
- User and developer guides
- Tutorials
- Architecture documentation

---

## Agent Configuration Structure

Each agent directory follows this structure:

```
openclaw-{agent-name}/
├── AGENTS.md          # Core agent documentation
├── SOUL.md            # Personality and philosophy
├── IDENTITY.md        # Agent identity and metadata
├── TOOLS.md           # Available tools (optional)
└── examples/          # Example outputs (optional)
```

## Orchestration Patterns

### 1. Project Initiation
```
1-main
├── 2-project-manager (planning)
├── 3-product-manager (requirements)
└── 4-system-architect (design)
```

### 2. Feature Development
```
1-main
├── 3-product-manager (requirements)
├── 4-system-architect (design)
├── 8-backend-engineer (API)
├── 10-frontend-engineer (UI)
├── 12-qa-engineer (testing)
└── 13-ops-engineer (deployment)
```

### 3. Full Stack Project
```
1-main
├── 2-project-manager (coordination)
├── 3-product-manager (PRD)
├── 4-system-architect (architecture)
├── 8-backend-engineer (server)
├── 10-frontend-engineer (web)
├── 11-mobile-engineer (mobile)
├── 12-qa-engineer (quality)
├── 14-security-engineer (security)
├── 13-ops-engineer (infrastructure)
├── 9-database-engineer (analytics)
└── 15-technical-writer (docs)
```

## Usage

### From Main Agent
The main agent automatically selects and coordinates subagents based on user requirements.

### Direct Invocation
Subagents can be invoked directly for specific tasks within their expertise area.

### Configuration
Agent behavior can be customized through configuration files and environment variables.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-20 | Initial agent ecosystem setup with 12 agents |
