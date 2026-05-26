# WPNinjasFI Intune MAA Notification Logic App Demo 21.5.2026

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fperamhe%2Fpublic-speaking%2Fmain%2F2026-05-21_WPNinjasFI_Live_Keilaniemi%2Fdemo-files%2Fazuredeploy.json)

## What is this?
This folder contains deployable ARM template for demo Logic Apps that I showed in my session at Workplace Ninja User Group Finland live event on May 21, 2026. 

The slides for the session are available here (In Finnish only): [Vähemmän klikkailua, enemmän automaatiota: Intunen ja Entran automatisointi Azurella](WPNinjasFI%20V%C3%A4hemm%C3%A4n%20klikkailua%2C%20enemm%C3%A4n%20automaatiota.pdf).

The examples are designed to demonstrate how to build a working automation using Logic Apps. The use-case in this demo is to get email notifications for pending Intune Multi Admin Approval requests.

NOTE: This is a demo/workshop template and the Logic Apps deployed with this template are not intended for production use. The Logic Apps in this template are designed to be simple and easy to understand for demonstration purposes, and they may not include all the error handling, security considerations, or best practices that would be necessary for a production implementation.

## What does the deployment include?

This ARM template deploys the following:

- A resource group (name is configurable with `resourceGroupName`, default is `wpninjasfi-intune-maa-notifications-demo`)
- API connection for Office 365 Outlook `Microsoft.Web/connections`
- Logic App workflow named `logic-wpninjasfi-hello-world-demo` (Demo 1 in the session)
- Logic App workflow named `logic-wpninjasfi-intune-maa-notifications-demo` (Demo 2 in the session)
- Logic App workflow named `logic-wpninjasfi-intune-maa-agent-demo` (Demo 3 in the session)


## Step-by-step deployment instructions
1. Click the "Deploy to Azure" button above and follow the instructions in Azure Portal to deploy the ARM template.
2. Set the `resourceGroupName` parameter (or keep the default) and enter the `adminEmail` parameter value during deployment. The `adminEmail` value is the recipient address used by both Logic Apps for notifications and error messages.
3. After deployment, navigate in Azure Portal to the resource group where the Logic Apps were deployed.
4. Authorize the Office 365 API connection to allow the Logic Apps to send emails by following these steps:
	1. In the resource group, open the API connection resource named `office365`.
	2. In the left menu, select `Edit API connection`.
	3. Click the `Authorize` button on the page.
	4. In the right-side pane, click `Authorize` again to start sign-in.
	5. Sign in with the Microsoft 365 account whose mailbox will be used to send the emails from the Logic App.
	6. Complete consent if prompted, then confirm the connection is authorized/connected.
   7. **Important:** Click the `Save` button at the top of the page to save the changes after authorizing the connection. If you navigate away from the page without saving, the connection will not be authorized and the Logic Apps will not be able to send emails.
5. Grant permissions to the identity of each of the two Intune MAA Logic Apps in Azure Portal to allow them to read the pending Intune Multi Admin Approval requests. You can do this by following these steps for each Logic App:
   1. Open Azure cloud shell in Azure Portal (if you haven't used Cloud Shell before, see here: https://learn.microsoft.com/en-us/azure/cloud-shell/get-started/classic?tabs=azurecli).
   2. Upload the `Add-MIGraphAPIAppRole.ps1` script from `demo-files/` to Cloud Shell (you can use the upload/download files button in Cloud Shell).
   3. In the resource group, open one of the Logic App resource.
   4. In the left menu, select `Identity` under `Settings`.
   5. On the `System assigned` tab, click the copy-to-clipboard icon next to the `Object (principal) ID` value.
   6. Go back to Cloud Shell and run the following command, replacing `<PRINCIPAL_ID>` with the value you just copied:
      ```powershell
      .\Add-MIGraphAPIAppRole.ps1 -IdentityPrincipalId <PRINCIPAL_ID>
      ```
   7. Repeat steps 3-6 for the other Logic App.

You are now ready to run the Logic Apps and get notifications for pending Intune Multi Admin Approval requests! 

**Note:** if you did not complete step 5 to grant permissions to the Logic Apps before trying to run them, there will be a delay before the granted permissions are effective due to platform caching of Managed Identity tokens (https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations#limitation-of-using-managed-identities-for-authorization)


