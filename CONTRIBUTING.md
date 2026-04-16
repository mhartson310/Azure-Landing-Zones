# Contributing to Azure Landing Zones

Thank you for your interest in contributing! This project aims to provide production-quality Terraform modules for Azure landing zones.

## 🤝 How to Contribute

### Reporting Issues

- **Search existing issues** first to avoid duplicates
- **Use issue templates** when available
- **Include details**: Terraform version, Azure provider version, error messages
- **Provide context**: What were you trying to accomplish?

### Suggesting Features

- **Check the roadmap** in Issues first
- **Explain the use case** - why is this needed?
- **Describe the solution** - how should it work?
- **Consider alternatives** - are there other ways to solve this?

### Submitting Code

1. **Fork the repository**
2. **Create a feature branch**
```bash
   git checkout -b feature/amazing-feature
```

3. **Make your changes**
   - Follow Terraform style conventions
   - Add/update documentation
   - Add examples if introducing new functionality
   - Test your changes

4. **Commit your changes**
```bash
   git commit -m "Add amazing feature"
```
   - Use clear, descriptive commit messages
   - Reference issue numbers when applicable

5. **Push to your fork**
```bash
   git push origin feature/amazing-feature
```

6. **Open a Pull Request**
   - Describe what changed and why
   - Reference related issues
   - Include before/after examples if applicable

## 📝 Code Standards

### Terraform Style

- **Follow [Terraform Style Guide](https://www.terraform.io/docs/language/syntax/style.html)**
- **Use `terraform fmt`** before committing
- **Use `terraform validate`** to check syntax
- **Document all variables** with description and type
- **Document all outputs** with description
- **Use meaningful resource names**

### Variable Naming

```hcl
# Good
variable "hub_vnet_address_space" {
  description = "Address space for hub VNet"
  type        = string
}

# Bad
variable "addr" {
  type = string
}
```

### Module Structure

Each module should include:
- `main.tf` - Primary resources
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `README.md` - Module documentation
- `versions.tf` - Provider version constraints (if needed)

### Documentation

- **Update README** when adding features
- **Include examples** for new functionality
- **Document breaking changes** clearly
- **Keep docs in sync with code**

### Testing

Before submitting:

```bash
# Format code
terraform fmt -recursive

# Validate syntax
cd examples/single-region
terraform init
terraform validate

# Check for issues
# (We'll add automated testing in the future)
```

## 🎯 What We're Looking For

**High Priority:**
- Bug fixes
- Documentation improvements
- Additional examples (multi-region, spoke networks)
- Cost optimization features
- Security enhancements

**Medium Priority:**
- New modules (spoke-network, firewall policies, etc.)
- CI/CD improvements
- Automated testing

**Nice to Have:**
- Additional Azure regions support
- Integration with other tools
- Performance improvements

## ❌ What We're NOT Looking For

- Breaking changes without discussion
- Overly complex solutions when simple ones exist
- Features specific to one use case (consider making it optional)
- Code that doesn't follow Terraform best practices

## 🐛 Reporting Security Issues

**DO NOT** open public issues for security vulnerabilities.

Instead, email: **security@hartsonadvisory.com**

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 💬 Questions?

- **Open a Discussion** for questions about usage
- **Open an Issue** for bugs or feature requests
- **Email** mario@hartsonadvisory.com for consulting inquiries

## 🙏 Thank You

Every contribution helps make Azure deployments better for everyone. Thank you for taking the time to contribute!

---

**Happy coding!** 🚀
