.. _delete-image-tags-in-the-docker-registry-8e2e91d42294:

========================================
Delete Image Tags in the Docker Registry
========================================

When deleting image tags in the registry.local docker registry, you should be
aware that the deletion of an **<image-name><tag-name>** will delete all tags
under the specified <image-name> that have the same 'digest' as the specified
<image-name:tag-name>.

The docker registry API v2 does not support deleting specific tags.
See, `https://github.com/distribution/distribution/issues/1566 <https://github.com/distribution/distribution/issues/1566>`_ .

For example:

jsmith/sampleimage-test:v1.0
jsmith/sampleimage-test:v1.1
jsmith/sampleimage-production:v1.0

If the above three image tags share the same digest in registry.local, then, if
'jsmith/sampleimage-test:v1.1' is deleted, then **ALL** other tags under
'jsmith/sampleimage-test' that have the **SAME** digest
(as jsmith/sampleimage-test:v1.1) are deleted. That is, both
'jsmith/sampleimage-test:v1.0' and 'jsmith/sampleimage-test:v1.1' will be
deleted, while 'jsmith/sampleimage-production:v1.0' with the same digest
but different <image-name> will not be deleted.


