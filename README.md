# **Metriport Deploy with CDK**

## **Description**

Reusable Github Action to deploy Metriport code to AWS using CDK.

## **Usage**

Within your Github workflow, declare a step like so:

```
...
jobs:
  ...
  the-job:
    ...
    steps:
      ...
      the-step:
        uses: metriport/deploy-with-cdk@master
        with:
          cdk_action: "deploy --verbose --require-approval never"
          cdk_version: "2.49.0"
          cdk_stack: "${{ inputs.stack }}"
          cdk_env: "${{ inputs.deploy_env }}"
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: us-east-1
```

Where:
- `with`: the inputs for the action - check the `action.yml` to find out which ones are required
- `env`: env vars specifying values for AWS CLI and CDK

For an example usage, check the Github workflows of https://github.com/metriport/metriport
