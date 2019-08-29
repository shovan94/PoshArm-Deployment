function New-ArmApplicationInsightsMetricAlert {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("ApplicationInsights")]
        $ApplicationInsights,
        [string]
        $ApiVersion = '2018-03-01',
        [string]
        $Description = "",
        [switch]
        $Disabled,
        [string]
        $Operator,
        [int]
        $Threshold,
        [string]
        $TimeAggregation,
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $FailedLocationCount,
        [ValidateRange(5, 1440)]
        [int]
        $WindowSizeInMinutes = 5,
        [PSCustomObject]
        $DataSource = @{ },
        [ValidateRange(0, 4)]
        [int]
        $Severity = 0,
        [ValidateRange(1, 60)]
        [int]
        $EvaluationFrequencyInMinutes = 1,
        [string]
        $ActionGroupId = ""

    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights metric alert")) {
        $windowSize = "PT$WindowSizeInMinutes" + "M"
        $evaluationFrequency = "PT$EvaluationFrequencyInMinutes" + "M"

        $ApplicationInsightsMetricAlert = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.Insights/metricAlerts'
            PSTypeName  = "ApplicationInsightsMetricAlert"
            type        = 'Microsoft.Insights/metricAlerts'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = [ordered]@{
                description         = $Description
                severity            = $Severity
                enabled             = -not $Disabled.ToBool()
                scopes              = @("/subscriptions/bb92196e-c69f-4dbc-87aa-62733759d9df/resourceGroups/connect-sacharjee-monitoring-eastus2/providers/microsoft.insights/webtests/Connect-ai-qhcsuuhafghss",
                    "/subscriptions/bb92196e-c69f-4dbc-87aa-62733759d9df/resourceGroups/connect-sacharjee-monitoring-eastus2/providers/microsoft.insights/components/ai-qhcsuuhafghss"
                )
                evaluationFrequency = $evaluationFrequency
                windowSize          = $windowSize
                criteria            = @{
                    "odata.type" = "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria"
                }
                actions             = @([PSCustomObject]@{
                        actionGroupId = "/subscriptions/bb92196e-c69f-4dbc-87aa-62733759d9df/resourceGroups/connect-sacharjee-monitoring-eastus2/providers/microsoft.insights/actionGroups/MyNewActionGroup-u7ecdugsjteju"
                    })
            }
            dependsOn   = @("/subscriptions/bb92196e-c69f-4dbc-87aa-62733759d9df/resourceGroups/connect-sacharjee-monitoring-eastus2/providers/microsoft.insights/webtests/Connect-ai-qhcsuuhafghss",
                "/subscriptions/bb92196e-c69f-4dbc-87aa-62733759d9df/resourceGroups/connect-sacharjee-monitoring-eastus2/providers/microsoft.insights/components/ai-qhcsuuhafghss",
                "/subscriptions/bb92196e-c69f-4dbc-87aa-62733759d9df/resourceGroups/connect-sacharjee-monitoring-eastus2/providers/microsoft.insights/actionGroups/MyNewActionGroup-u7ecdugsjteju")
        }

        $ApplicationInsightsMetricAlert.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsMetricAlert
    }
}