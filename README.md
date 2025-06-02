# Kind Anchor Lab

![Kubernetes](https://img.shields.io/badge/kubernetes-kind-blue)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A fully automated **local Kubernetes lab** that mimics production infrastructure, with **HTTPS via TLS certificates** using [Anchor](https://anchor.dev) and [lcl.host](https://lcl.host).  
Ideal for developers aiming for **Dev/Prod parity**.

---

## 🧠 Why This Project?

Local development environments often skip over encryption and ingress critical parts of production setups. This project aims to close that gap:

- ✅ Run Kubernetes locally with [kind](https://kind.sigs.k8s.io/)
- ✅ Simulate cloud LoadBalancers using [cloud-provider-kind](https://github.com/kubernetes-sigs/cloud-provider-kind)
- ✅ Issue trusted TLS certs via [Anchor](https://anchor.dev)
- ✅ Use any `*.lcl.host` domain that resolves to `localhost`. [lcl.host](https://lcl.host/)
- ✅ Deploy services via Helm and test over HTTPS just like production

No need to touch `/etc/hosts`, run openssl manually, or debug nginx configs.

---

## 🌐 What It Looks Like

You’ll be able to run:

```bash
curl https://kind-anchor-lab.lcl.host:32769/alice
```
And behind the scenes:

- Traffic hits an Envoy proxy simulating a LoadBalancer
- Routes to NGINX ingress
- Terminates TLS via cert-manager + Anchor
- Reaches your service inside the Kind cluster

## 🚀 Quickstart

### Prerequisites

- [Docker](https://www.docker.com/) or [Podman](https://podman.io/)
- [kind](https://kind.sigs.k8s.io/)
- [helm](https://helm.sh/) 
- [GNU Make](https://www.gnu.org/software/make/)
- [Anchor CLI](https://anchor.dev/docs)
- [cloud-provider-kind](https://github.com/kubernetes-sigs/cloud-provider-kind)

### Create an Anchor Account and Service (Critical Step)

Before running the lab, you must create a service in the Anchor UI:

1. Create a free account on [Anchor](https://anchor.dev/) if you haven’t already.
2. Manually create a service named `kind-anchor-lab` in the Anchor dashboard. This service will be used by the local lab to request and manage TLS certificates.

Here's how the service creation screen should look:

![Creating new Service in Anchor UI](https://cdn.loncar.net/anchor-create-service.png)

> Note: Anchor needs to know which service will be requesting certificates. The Kind Cloud Provider will handle the actual port mapping (typically :32769), so the port you choose in Anchor's UI is just for organization purposes.

## 🛠️ Setup & Usage

### Clone and enter the repo:

```bash
git clone https://github.com/loncarales/kind-anchor-lab.git
cd kind-anchor-lab
make
```

### Run the setup steps:

```bash
make cluster          # Create Kind cluster
make ingress          # Install NGINX ingress controller
make cert-manager     # Install cert-manager
```
### Configure TLS with Anchor

```bash
make anchor           # Configure Anchor + TLS issuer
```

This will:

- Install the Anchor CLI
- Initialize your local CA using anchor lcl
- Prompt you to run the following to retrieve credentials:

```bash
anchor service env --org <ORG_NAME> --realm localhost --service <SERVICE_NAME> --env-output dotenv
```

Once run, the credentials (ACME_HMAC_KEY, ACME_DIRECTORY_URL, and ACME_KID) will be copied to your clipboard.

### 🔐 Manual Step Required:

Paste these credentials into anchor-lab/secrets.yaml using the provided template in:

```bash
anchor-lab/secrets-template.yaml
```

This file will be used by your Helm chart to create the proper Kubernetes secrets for cert-manager.

### In a separate terminal, run:

```bash
make cloud            # Starts the LoadBalancer simulation with Envoy
```

### Finally deploy services via Helm

```bash
make helm             # Deploy services via Helm
```

## 📋 Makefile Commands

| Command             | Description                                                          |
|---------------------|----------------------------------------------------------------------|
| `make`              | Displays this help                                                   |
| `make cluster`      | Create Kind cluster                                                  |
| `make ingress`      | Deploy NGINX ingress controller                                      |
| `make cert-manager` | Install cert-manager                                                 |
| `make anchor`       | Install Anchor CLI and configure TLS issuer                          |
| `make helm`         | Deploy Helm chart with Ingress and services                          |
| `make cloud`        | **Run in separate terminal** — starts Envoy-based LoadBalancer proxy |
| `make delete`       | Tear down the Kind cluster                                           |

## 📁 What's Inside

- scripts/ — all provisioning logic (cluster, ingress, certs, logging)
- anchor-lab/ — your Helm chart with services and Ingress

## 🔐 TLS the Easy Way

Thanks to lcl.host, you can use any subdomain (e.g., kind-anchor-lab.lcl.host) without DNS hacks:

```bash
dig any-subdomain.lcl.host +short
# 127.0.0.1
```

And thanks to Anchor, your certs are automatically:

- Requested via ACME
- Issued locally
- Managed with cert-manager

## ✅ TODO

- [] Enhance automation (e.g., generate secrets.yaml from clipboard or .env)
- [] Add a video walkthrough demo of the setup and usage

## 📜 License

MIT - see [LICENSE](LICENSE)

## 📝 Blog Post

Read the full background story and reasoning in the blog: [Achieving Dev/Prod Parity with Local Kubernetes and TLS](https://TBA.com)

## ❤️ Credits

- Inspired by [12-Factor Dev/Prod Parity](https://12factor.net/dev-prod-parity)
- Made possible by the open-source community
- Developed with ❤️ by Aleš Lončar
