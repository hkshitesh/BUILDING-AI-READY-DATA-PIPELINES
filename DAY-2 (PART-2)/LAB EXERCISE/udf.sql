CREATE OR REPLACE FUNCTION get_jira_issue(issue_key VARCHAR)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'get_issue'
EXTERNAL_ACCESS_INTEGRATIONS = (jira_integration)
PACKAGES = ('requests')
SECRETS = ('cred' = jira_api_token)
AS
$$
import _snowflake
import requests

def get_issue(issue_key):
    credentials = _snowflake.get_username_password('cred')
    url = f"https://hkshitesh.atlassian.net/rest/api/3/issue/{issue_key}"
    response = requests.get(
        url,
        auth=(credentials.username, credentials.password),
        headers={"Accept": "application/json"}
    )
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.status_code, "message": response.text}
$$;
