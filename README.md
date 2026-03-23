# cloudinit

Merge `base.yml` with extra cloud-init files and substitute `${...}` env vars.

`base.yml` is the base cloud-init configuration that includes common setup shared across all builds (e.g. swap, packages, SSH hardening, firewall rules, user accounts).

## Usage

Environment variables are used to replace `${...}` placeholders in the cloud-init YAML
(e.g. `${hostname}`, `${ssh_port}`, `${password}`). Pass them inline or via a `.env` file.

### Base only

```bash
hostname=myhost ssh_port=2222 password=secret bash <(curl -fsSL https://raw.githubusercontent.com/TheR1D/cloudinit/main/build.sh)
```

### Merge

```bash
hostname=myhost ssh_port=2222 bash <(curl -fsSL https://raw.githubusercontent.com/TheR1D/cloudinit/main/build.sh) extra.yml [more.yml ...]
```

### ENV file

```bash
set -a && source .env && set +a && bash <(curl -fsSL https://raw.githubusercontent.com/TheR1D/cloudinit/main/build.sh)
```

### 1Password CLI

```bash
op run --no-masking --environment "xyz" --environment "abc" -- bash <(curl -fsSL https://raw.githubusercontent.com/TheR1D/cloudinit/main/build.sh) extra.yml
```
