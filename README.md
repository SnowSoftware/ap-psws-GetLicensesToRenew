# ap-psws-GetLicensesToRenew

## Description
Snow Automation Platform PowerShell WebService that retrieves licenses from Snow License Manager. Will return license(s) with renewal date within the defined amount of days. Renewal date is set in a date license custom field.

## Object properties
Licenses returned will have the following properties:

* RenewalDate (Custom)
* Id
* ApplicationName
* ManufacturerName
* Metric
* AssignmentType
* UpdatedDate
* UpdatedBy
* AutomaticDowngrade
* UpgradeRights
* InvoiceReference
* PurchaseDate
* PurchasePrice
* PurchaseCurrency
* Quantity
* Vendor
* ExternalId
* InstallationMedia
* LicenseProofLocation
* LicenseKeys
* Notes
* IsIncomplete
* CustomFields
* Allocations
* SKU
* LegalOrganisation
* IsUpgrade
* UpgradeFromLicenseID
* BaseLicenseQuantityToUpgrade
* SubscriptionValidFrom
* SubscriptionValidTo
* IsSubscription
* CrossEditionRights
* DowngradeRights
* AutoAllocate
* MaintenanceIncludesUpgradeRights
* MaintenanceAccordingToAgreement
* MaintenanceAndSupportValidFrom
* MaintenanceAndSupportValidTo
* AgreementNumber
* ProductDescription

```json
['RenewalDate','Id','ApplicationName','ManufacturerName','Metric','AssignmentType','PurchaseDate','Quantity','IsIncomplete','UpdatedDate','UpdatedBy']
```

## Repository
This script is maintained in the GitHub Repository found [here](https://github.com/SnowSoftware/ap-psws-GetLicensesToRenew).  
Please use GitHub issue tracker if you have any issues with the module. 