import openstackdocstheme as osdt

def _html_page_context(app, pagename, templatename, context, doctree):
    context['this_version']=app.config.starlingxdocs_plus_this_version
    context['other_versions']=app.config.starlingxdocs_plus_other_versions
    context['bug_project'] = app.config.starlingxdocs_plus_bug_project
    context['bug_tag'] = app.config.starlingxdocs_plus_bug_tag

def setup(app):
    app.add_html_theme(
        'openstackdocs',
        osdt.__path__[0] + '/theme/openstackdocs',
    )
    app.add_html_theme(
        'starlingxdocs',
        osdt.__path__[0] + '/theme/starlingxdocs',
    )
    app.add_config_value('starlingxdocs_plus_this_version','','env')
    app.add_config_value('starlingxdocs_plus_other_versions', [], 'env')
    app.add_config_value('starlingxdocs_plus_repo_name','','env')
    app.add_config_value('starlingxdocs_plus_project','','env')
    app.add_config_value('starlingxdocs_plus_auto_name', False, 'env')
    app.add_config_value('starlingxdocs_plus_bug_project','','env')
    app.add_config_value('starlingxdocs_plus_bug_tag','','env')
    app.connect('html-page-context', _html_page_context)
    app.add_css_file("custom.css")