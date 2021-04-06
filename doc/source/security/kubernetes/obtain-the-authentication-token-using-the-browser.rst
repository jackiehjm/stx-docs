
.. fvd1581384193662
.. _obtain-the-authentication-token-using-the-browser:

=================================================
Obtain the Authentication Token Using the Browser
=================================================

You can obtain the authentication token using the **oidc-auth-apps** |OIDC|
client web interface.

.. rubric:: |context|

Use the following steps to obtain the authentication token for id-token and
refresh-token using the **oidc-auth-apps** |OIDC| client web interface.

.. rubric:: |proc|

#.  Use the following URL to login into **oidc-auth-apps** |OIDC| client:

    ``https://<oam-floating-ip-address>:30555``

#.  If the |prod| **oidc-auth-apps** has been configured for multiple
    '**ldap**' connectors, select the Windows Active Directory server for
    authentication.

#.  Enter your Username and Password.

#.  Click Login. The ID token and Refresh token are displayed as follows:

    .. code-block:: none

        ID Token:

        eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4ZjZkYjcxNGI4ODQ5ZjZlNmExM2Y2ZTQzODVhMWE1MjM0YzE1NTQifQ.eyJpc3MiOiJodHRwczovLzEyOC4yMjQuMTUxLjE3MDozMDU1Ni9kZXgiLCJzdWIiOiJDZ2R3ZG5SbGMzUXhFZ1JzWkdGdyIsImF1ZCI6InN0eC1vaWRjLWNsaWVudC1hcHAiLCJleHAiOjE1ODI1NzczMTksImlhdCI6MTU4MjU3NzMwOSwiYXRfaGFzaCI6ImhzRG1kdTFIWGFCcXFNLXBpYWoyaXciLCJlbWFpbCI6InB2dGVzdDEiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6InB2dGVzdDEifQ.TEZ-YMd8kavTGCw_FUR4iGQWf16DWsmqxW89ZlKHxaqPzAJUjGnW5NRdRytiDtf1d9iNIxOT6cGSOJI694qiMVcb-nD856OgCvU58o-e3ZkLaLGDbTP2mmoaqqBYW2FDIJNcV0jt-yq5rc9cNQopGtFXbGr6ZV2idysHooa7rA1543EUpg2FNE4qZ297_WXU7x0Qk2yDNRq-ngNQRWkwsERM3INBktwQpRUg2na3eK_jHpC6AMiUxyyMu3o3FurTfvOp3F0eyjSVgLqhC2Rh4xMbK4LgbBTN35pvnMRwOpL7gJPgaZDd0ttC9L5dBnRs9uT-s2g4j2hjV9rh3KciHQ

        Access Token:

        wcgw4mhddrk7jd24whofclgmj

        Claims:

        {
          "iss": "https://128.224.151.170:30556/dex",
          "sub": "CgdwdnRlc3QxEgRsZGFw",
          "aud": "stx-oidc-client-app",
          "exp": 1582577319,
          "iat": 1582577319,
          "at_hash": "hsDmdu1HXaBqqM-piaj2iw",
          "email": "testuser",
          "email_verified": true,
          "groups": [
            "billingDeptGroup",
            "managerGroup"
           ],
          "name": "testuser"
        }

        Refresh Token:

        ChljdmoybDZ0Y3BiYnR0cmp6N2xlejNmd3F5Ehlid290enR5enR1NWw1dWM2Y2V4dnVlcHli

#.  Use the token ID to set the Kubernetes credentials in kubectl configs:

    .. code-block:: none

        ~(keystone_admin)]$ TOKEN=<ID_token_string>
        ~(keystone_admin)]$ kubectl config set-credentials testuser --token $TOKEN

#.  Switch to the Kubernetes context for the user, by using the following
    command, for example:

    .. code-block:: none

        ~(keystone_admin)]$ kubectl config use-context testuser@mywrcpcluster

#.  Run the following command to test that the authentication token
    validates correctly:

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get pods --all-namespaces


