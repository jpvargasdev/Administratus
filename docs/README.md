# 🏛️ Administratus

“Records are eternal. Obedience is eternal. Only drift is heresy.” – Common edict of the Administratum


# 📜 About

Administratus is the central archive of truth for a homelab GitOps system. It contains the manifests, configuration, and decrees that define the desired state of your machines.

From this vault, Magos_Dominus reads and enforces the sacred instructions, reconciling the written word with the material world. Here, infrastructure is not managed but commanded—every commit a mandate, every file a law.


## Homelab Specs:

- Nuc 12 Extreme i7
- SSD 2TB
- RTX 4060 TI 16GB
- Linux

The goal is to apply GitOps principles (single source of truth in Git, reproducible deployments, secrets managed with SOPS) without Kubernetes or heavy tooling, using Podman Compose and a lightweight loop running on a home server.


## 📦 Architecture
•	NUC 12 i7 with Linux (rootless Podman).
•	Repositories:
	•	Deck-FPV: Go apps (e.g. license-admin/keyfoundry) + workflows publishing container images to GHCR.
	•	homelab-gitops: this repo, which describes how apps and base services are deployed.
•	GitOps loop on the NUC:
	1.	git pull from this repo.
	2.	Decrypt secrets with SOPS + age.
	3.	podman-compose pull && up -d per stack.



## 📂 Repository layout

  backup/         # backup scripts
  configs/        # non-sensitive .env files (public configs)
  docs/           # documentation
  proxy/          # Traefik and reverse proxy
  secrets/        # *.secret.env encrypted with SOPS
  sops.yaml       # SOPS configuration (rules and keys)
  stacks/         # one stack per service (keyfoundry, postgres, diun, etc.)

## 🔑 Secrets management
	•	Secrets (*.secret.env) are encrypted with SOPS and age.
	•	To edit a secret:

  ```sops secrets/keyfoundry.secret.env```

	•	To decrypt manually:
  ```sops -d secrets/keyfoundry.secret.env```

## 🚀 Deployment flow
1.	Build & publish
	Each app repo (e.g. Deck-FPV) builds container images and pushes them to GHCR.
2.	New image detection
•	Diun runs on the NUC and monitors registries.
•	When a new image appears, it triggers a hook that applies the image policy.
3.	Image Policy (mini-Flux)
•	Policies in policies/*.yml define which images are allowed (e.g. semver >=1.2.0, architecture amd64, cosign signature required).
•	If the image passes the policy, the script updates this repo (stacks/.../compose.yml), commits as a bot, and pushes to main.
4.	GitOps loop
•	The NUC runs git pull, decrypts secrets, and redeploys stacks with podman-compose.



## 🛠️ Current stacks
	•	keyfoundry: license-admin, internal Deck-FPV license issuing/revocation tool.
	•	postgres: shared PostgreSQL database (pg-main).
	•	proxy (traefik): single HTTP/HTTPS entrypoint.
	•	diun: image update notifier + GitOps trigger.

Planned: immich (photo management), n8n (automation).



## 🔒 Security
	•	Secrets encrypted in Git with SOPS.
	•	Only the bot (GitHub App or fine-grained PAT with minimal scope) can push to main.
	•	Branch protection on main (lint, sops-validate, gitleaks checks required).
	•	Images pinned by digest in production.
	•	Bot commits signed with its own identity.



## 📜 License

MIT. All content in this repo is licensed under the MIT License.
