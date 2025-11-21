# Copilot Instructions for freiwasser.org

## Documentation & Diagrams

### Diagrams
- **Always use Mermaid for diagrams** instead of ASCII art
- Supported diagram types: flowchart, graph, sequence, state, class, ER, Gantt, pie, etc.
- Use descriptive labels and clear hierarchies
- Example:


  ```mermaid
  graph TB
    A["Component A"] --> B["Component B"]
    B --> C["Component C"]
```

### Documentation Format
- Use Markdown for all documentation files
- Keep implementation roadmaps concise and bullet-list style
- Include clear phase breakdowns with checkboxes
- Provide deployment checklists
- Document architecture with both visual diagrams and written descriptions

## Code Standards

### Infrastructure as Code (Terraform)
- Organize modules logically (kubernetes, network, database, storage, monitoring)
- Use consistent variable naming conventions
- Always include git-ignored `secrets.sops.yaml` for sensitive data
- Document SOPS usage in README for decryption workflow

### Go API
- Follow standard Go project layout
- Use REST conventions for API endpoints
- Implement middleware for JWT validation and region-based access control
- Include audit logging for data contribution endpoints

### Kubernetes Manifests
- Organize by service in separate subdirectories
- Include resource requests/limits
- Use ConfigMaps for region metadata
- Use Secrets for credentials

## Security

### Secrets Management
- Never commit plaintext secrets
- Use SOPS for encrypted secrets files with `.sops.yaml` pattern
- Load secrets via `sops exec-env` in CI/CD and terraform commands
- PGP key for SOPS encryption should be documented in implementation plan

### Access Control
- Implement JWT claims with regions and roles
- Use region column in PostGIS for scalable access control
- Support role-based access: viewer, contributor, admin
- Free tier gets public Europe data; paid tiers unlock additional regions

## Git Workflow

### Branch Strategy
- Use descriptive branch names (wip, feature-*, bugfix-*, etc.)
- Keep commits atomic and well-documented
- Include GPG signatures for releases

### File Organization
- Infrastructure code in `infrastructure/` directory
- K8s manifests in `infrastructure/k8s-manifests/`
- Implement roadmap in `implementaion_roadmap.md` (note: typo preserved for consistency)
- README with setup instructions and workflows

## Multi-Region Architecture

### Region Design
- Regions are **metadata**, not infrastructure
- Use single PostGIS database with `region` column
- Store region definitions in `regions.json` format
- Europe is MVP (free); other regions are paid add-ons
- Zero-downtime region additions via Terraform variable updates

### Data Contribution
- Authenticated endpoints only for data submissions
- Role-based validation (contributor role required)
- PostGIS updates from Go API
- Audit logging for compliance

## Monitoring & Observability

### Expected Metrics
- K8s cluster health (node status, pod availability)
- Database replication status
- API response times and error rates
- Tile server cache hit ratio
- Resource utilization (CPU, memory, disk)

### Optional Services
- Grafana for dashboards (if server capacity allows)
- Prometheus for metrics collection
- Loki for log aggregation (future)

---

**Last Updated**: November 21, 2025
