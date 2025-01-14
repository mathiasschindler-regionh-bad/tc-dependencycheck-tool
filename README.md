# Team Caboodle: Dependency Check Automation Tool

This tool is built to ease and automate the process of checking for dependencies in the various subsystems of the Cogito infrastructure utilized in Region Hovedstaden and Region Sjælland. This ensures smooth operation and compatibility between the different subsystems.

## Prerequisites

#### Operating System
This tool requires a Windows operating system with PowerShell installed. 

#### Git
Ensure Git is installed and accessible in your system's PATH variable. To verify, open PowerShell and run:
   ```powershell
   git --version
   ```
If Git is not installed, download it from Region Hovedstaden's internal tool [`Softwareshoppen`](https://softwarecentral.regionh.top.local/Shopping.aspx).


#### GitHub Access
This tool requires HTTPS access to GitHub. The script dynamically checks if your local machine has the required access properly set up. If not, follow the steps
1. Open a new PowerShell terminal
2. Execute the command 
    ```powershell
    git ls-remote <repository-url>
    ```
3. A browser window should now open for you to authenticate (be patient, it can take some time). Since SAML SSO is used in Region Hovedstaden's GitHub Enterprise setup, you will be prompted to log in via your organization's GitHub page.
4. GitHub's credential manager will store your login details, so you won't need to re-authenticate for future Git operations.


## Usage
To run this automation tool follow the steps:
1. Open a new PowerShell terminal
2. Navigate to the desired destination where the local clone should be stored:
    ```powershell
    cd <destination-directory>
    ```
2. Clone this repo to your local machine operating on Windows
    ```powershell
    git clone <repository-url>
    ```
3. Navigate to the directory containing the local clone of this repo
    ```powershell
    cd <repository-folder>
    ```
4. Execute the script
    ```powershell
    .\TC-DependencyCheck-Tool.ps1
    ```
5. Follow the instructions in your PowerShell terminal provided by the tool


## Reference
For any issues, bug reports, or suggestions, please contact the original developer, Mathias Schindler, at mathias.schindler.01@regionh.dk.


### License
This project is licensed under the [MIT License](LICENSE.txt).