# Kubelist - Safe Kubectl Wrapper

A security-focused wrapper around `kubectl` that restricts execution to safe, read-only commands. Kubelist prevents accidental or malicious destructive operations on your Kubernetes cluster while still allowing essential inspection and monitoring tasks.

## Features

- **Security First**: Whitelist approach - only explicitly safe commands are allowed
- **Zero Configuration**: Works with your existing kubectl setup and kubeconfig
- **Clear Error Messages**: Helpful feedback when unsafe commands are blocked  
- **Full kubectl Compatibility**: Passes through all arguments to kubectl for allowed commands
- **Comprehensive Documentation**: Includes detailed man page and help system

## Safe Commands

Kubelist allows the following read-only kubectl operations:

| Command | Description |
|---------|-------------|
| `get` | Display resources (pods, services, deployments, etc.) |
| `describe` | Show detailed resource information and events |
| `logs` | View container logs |
| `top` | Display resource usage (requires metrics-server) |
| `version` | Show kubectl and Kubernetes version |
| `cluster-info` | Display cluster information |
| `explain` | Get resource documentation |
| `api-resources` | List available API resources |
| `api-versions` | List supported API versions |
| `config view` | Show kubeconfig settings (without secrets) |
| `config get-contexts` | List available contexts |
| `config current-context` | Show current context |
| `config get-clusters` | List configured clusters |
| `config get-users` | List configured users |

## Blocked Commands

The following potentially dangerous operations are blocked:

- **Destructive**: `delete`, `patch`, `replace`
- **Creation**: `create`, `apply`  
- **Scaling**: `scale`, `autoscale`
- **Rollouts**: `rollout`
- **Interactive**: `exec`, `attach`
- **Port Operations**: `port-forward`, `proxy`
- **File Operations**: `cp`
- **Editing**: `edit`

## Installation

### Quick Install

```bash
# Download and install kubelist
curl -o kubelist https://raw.githubusercontent.com/your-username/kubelist/main/kubelist
chmod +x kubelist
sudo mv kubelist /usr/local/bin/

# Install man page (optional)
curl -o kubelist.1 https://raw.githubusercontent.com/your-username/kubelist/main/man/man1/kubelist.1
sudo mv kubelist.1 /usr/local/share/man/man1/
sudo mandb
```

### Manual Install

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/kubelist.git
   cd kubelist
   ```

2. **Install the script**:
   ```bash
   sudo cp kubelist /usr/local/bin/
   sudo chmod +x /usr/local/bin/kubelist
   ```

3. **Install man page** (optional):
   ```bash
   sudo cp man/man1/kubelist.1 /usr/local/share/man/man1/
   sudo mandb
   ```

### Verify Installation

```bash
kubelist --version
kubelist --help
man kubelist  # if man page was installed
```

## Usage

Use `kubelist` exactly like you would use `kubectl` for read-only operations:

```bash
# View pods
kubelist get pods

# Get detailed deployment information  
kubelist describe deployment nginx

# Follow logs from a specific container
kubelist logs my-pod -c my-container -f

# Check resource usage
kubelist top nodes

# View cluster information
kubelist cluster-info

# Check current context
kubelist config current-context
```

### Error Examples

When you try to run unsafe commands, kubelist will block them:

```bash
$ kubelist delete pod my-pod
Error: Command 'delete' is not allowed
This command may modify cluster state or perform unsafe operations.
Safe commands: get describe logs top version cluster-info explain api-resources api-versions
Use 'kubectl' directly if you need to run unsafe commands.
```

## Use Cases

### Development Teams
- Give developers read-only access to production clusters
- Prevent accidental resource deletion during debugging
- Allow log viewing and resource inspection without modification rights

### CI/CD Pipelines  
- Use in monitoring and health check scripts
- Safe cluster inspection in automated workflows
- Prevent pipeline scripts from making unintended changes

### Training Environments
- Allow students to explore Kubernetes safely
- Prevent destructive operations during learning
- Maintain cluster stability in shared environments

### Audit and Compliance
- Provide read-only access for compliance officers
- Enable monitoring without modification capabilities
- Create audit trails of safe operations only

## Configuration

Kubelist uses your existing kubectl configuration:

- **Kubeconfig**: Respects `KUBECONFIG` environment variable and `~/.kube/config`
- **Context**: Works with your current kubectl context
- **Authentication**: Uses your existing kubectl authentication
- **Namespaces**: Respects namespace settings and `-n` flags

## Requirements

- **kubectl**: Must be installed and in your PATH
- **Bash**: Requires bash shell (version 4.0+)
- **Kubernetes Cluster**: Access to a Kubernetes cluster (same as kubectl)

## Development

### Project Structure

```
kubelist/
├── kubelist           # Main executable script
├── man/man1/          # Man page directory
│   └── kubelist.1     # Man page source
├── agents.md          # Development guidelines
└── README.md          # This file
```

### Testing

Test the script with various kubectl commands:

```bash
# Test safe commands (should work)
./kubelist get pods
./kubelist describe nodes
./kubelist logs my-pod

# Test unsafe commands (should be blocked)  
./kubelist delete pod my-pod
./kubelist apply -f deployment.yaml
./kubelist exec my-pod -- /bin/bash
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the guidelines in `agents.md`
4. Test thoroughly with various kubectl commands
5. Update documentation if needed
6. Submit a pull request

## Security Considerations

- **Whitelist Approach**: Only explicitly allowed commands can execute
- **No Bypass**: Cannot be used to circumvent kubectl's authentication
- **Transparent**: All allowed commands are passed directly to kubectl
- **Auditable**: Clear logging of blocked command attempts
- **Fail-Safe**: Defaults to denying unknown commands

## License

MIT License - see LICENSE file for details.

## Support

- **Issues**: Report bugs and feature requests on GitHub
- **Documentation**: Use `kubelist --help` or `man kubelist`
- **Community**: Join discussions in GitHub issues

## Changelog

### v1.0.0 (2025-09-13)
- Initial release
- Core safety features implemented
- Comprehensive man page
- Full kubectl argument passthrough
- Config subcommand support
