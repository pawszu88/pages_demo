# 03_02 Continuous Deployment for Github Pages

GitHub Pages is a free service provided by GitHub that lets you host static websites directly from our GitHub repositories.

You can use HTML or markdown to design webpages and then, using GitHub Actions, deploy the site to a publicly accessible URL.

## GitHub Pages Repo and Site Visibility by Plan

When working with GitHub Pages, it's important to understand the distinction between **repository visibility** and **site visibility**:

- **Repository visibility** refers to who can access the source code repository (public, private, or internal). This determines whether you can use a repository to host a GitHub Pages site.

- **Site visibility** refers to who can access the published GitHub Pages website itself. This is separate from repository visibility; even if your repository is private, the published site may still be publicly accessible on the internet, depending on your GitHub plan.

The following matrix outlines how these two types of visibility interact across different GitHub plans:

| Plan / context | Repo visibility allowed for Pages | Site visibility options |
| -------------- | --------------------------------- | ----------------------- |
| Free (personal) | Public only. Private repos cannot be used for Pages. | Public only. Any Pages site is public on the internet. |
| Free for organizations | Public only for Pages. | Public only. Sites are public if enabled. |
| Pro (personal) | Public and private repos can host Pages. | Public only. Sites are public even when repo is private. |
| Team (organization, non‑Enterprise) | Public and private repos can host Pages. | Public only. No private Pages; org admins can only allow/deny public sites. |
| Enterprise Cloud (org, no EMU) | Public, private, internal repos can host Pages. | Public or private per site. Private = only users with repo read access. |
| Enterprise Cloud (org, with EMU enabled) | Private and internal repos (org‑scoped). | Private only. All Pages sites restricted to enterprise members. |
| Enterprise Server (self‑hosted) | Public and private repos (per instance policy). | Public by default; private sites require Enterprise Cloud (not Server). |

## References

| Reference | Description |
|----------|-------------|
| [Creating a GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site) | Official GitHub documentation for creating and configuring GitHub Pages sites |
| [Hugo Project Details](./HUGO_PROJECT_DETAILS.md) | Documentation for the Hugo project used in this lesson |

## Lab: Deploy a Hugo Static Site to GitHub Pages

In this lab, you’ll deploy a **Hugo-based static website** to **GitHub Pages** using a GitHub-provided Actions workflow. By the end, your site will be live at a public `github.io` URL.

> [!IMPORTANT]
> If you’re using a **free GitHub account**, the repository **must be public** to deploy a GitHub Pages site.

### Prerequisites

Before you begin, make sure you have the exercise files for this lesson downloaded to your local system.

### Instructions

#### Step 1: Create a New Public Repository

1. From GitHub, create a **new repository**.
2. Give the repository a name (for example: `pages_demo`).
3. Ensure the repository is set to **Public**.
4. Select **Add a README**.
5. Create the repository.

#### Step 2: Upload the Exercise Files

1. From the **repository home page**, select **Add file → Upload files**.
2. Open your local file browser.
3. **Select all exercise files** and drag them into the upload area.
4. Commit the uploaded files.
5. Verify the directory structure matches the project layout exactly.

> [!IMPORTANT]
> Hugo requires content to be placed in specific directories. An incorrect structure will prevent the site from building correctly. See [Hugo Project Details](./HUGO_PROJECT_DETAILS.md#project-structure) for more information on the project structure.

#### Step 3: Update the Hugo Configuration in `config.toml`

1. Open the `config.toml` file in the repository.
2. Select the **edit (pencil) icon**.
3. Locate the `baseURL` setting at the top of the file.
4. Replace the placeholders with your values:

   - Replace `GITHUB_USER_NAME` with your GitHub username
   - Replace `GITHUB_REPO_NAME` with your repository name

   **Example:**

   For GitHub user `automate6500` using repository `pages_demo` the `baseURL` starting with:

   ```yaml
   baseURL = "https://GITHUB_USER_NAME.github.io/GITHUB_USER_NAME-GITHUB_REPO_NAME/"
   ```

   would become:

   ```yaml
   baseURL = "https://automate6500.github.io/automate6500-pages_demo/"
   ```

5. Commit the changes.

#### Step 4: Enable GitHub Pages with GitHub Actions

1. Open the **Settings** tab for the repository.
2. In the left navigation, select **Pages** under *Code and automation*.
3. Under **Build and deployment**, set the **Source** to **GitHub Actions**.

After the page refreshes, GitHub will suggest workflows for deployment.

#### Step 5: Configure the Hugo Deployment Workflow

1. Locate the **Hugo** workflow option.
2. Select **Configure**.

    Before committing the file, take a moment to review the workflow:

    - **Permissions** allow the workflow to read the repository and write to GitHub Pages.
    - **Concurrency** prevents overlapping deployments.
    - The **build job**:
        - Installs the Hugo CLI
        - Checks out the repository
        - Builds the static site
        - Uploads the output as an artifact

    - The **deploy job**:
        - Deploys the artifact to GitHub Pages
        - Defines a deployment environment with a site URL

3. Commit the workflow.

#### Step 6: Monitor the Deployment

1. Navigate to the **Actions** tab.
2. Select the running workflow.
3. Wait for the workflow to complete successfully.

When the workflow finishes:

- The **build job** summary shows the generated artifact.
- The **deploy job** displays a **deployment URL**.

#### Step 7: View the Live Site

1. Select the deployment URL provided by the workflow.
2. Confirm your Hugo site is live and publicly accessible.

In just a few steps, you’ve gone from raw files to a fully deployed Hugo static site using GitHub Pages and GitHub Actions.

## Shenanigans

<!-- FooterStart -->
---
[← 03_01 Deploying Software with Github actions](../03_01_deploying_software_with_github_actions/README.md) | [03_03 Create a Service account for Deployments →](../03_03_service_account/README.md)
<!-- FooterEnd -->
