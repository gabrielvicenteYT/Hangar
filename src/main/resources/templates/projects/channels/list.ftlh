<#import "/spring.ftl" as spring />
<#import "*/utils/hangar.ftlh" as hangar />
<#import "*/layout/base.ftlh" as base />
<#import "*/projects/channels/helper/modalManage.ftlh" as modalManage />
<#import "*/utils/form.ftlh" as form>
<#import "*/utils/csrf.ftlh" as csrf>

<#assign scriptsVar>
    <script <#--@CSPNonce.attr-->>
      window.PROJECT_OWNER = '${p.project.ownerName}';
      window.PROJECT_SLUG = '${p.project.slug}';
      window.DEFAULT_HEX = '${config.channels.colorDefault.hex}';
      window.CHANNEL_CREATE_ROUTE = '${Routes.CHANNELS_CREATE.getRouteUrl(p.project.ownerName, p.project.slug)}';
    </script>
    <script type="text/javascript" src="<@hangar.url "js/channelManage.js" />"></script>
</#assign>

<#assign message><@spring.messageArgs code="channel.list.title" args=[p.project.ownerName, p.project.slug] /></#assign>
<@base.base title=message additionalScripts=scriptsVar>
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><@spring.message "channel.list.title" /></h3>
                </div>
                <div class="card-body">
                    <p class="minor create-blurb">
                        <@spring.message "channel.list.description" />
                    </p>

                    <table class="table no-border centered">
                        <tbody>
                        <#list channels as channel, versions>
                        <tr>
                            <td>
                                <div class="channel"
                                     style="background-color: ${channel.color.hex}">${channel.name}</div>
                            </td>
                            <td>
                                <div class="btn btn-sm yellow" data-toggle="modal" data-target="#channel-settings"
                                     id="channel-edit-${channel.id}">Edit
                                </div>
                            </td>
                            <#if channels?size gt 1>
                                <td>
                                    <div class="btn btn-sm yellow"
                                            <#if versions gt 0>
                                                id="channel-delete-${channel.id}" data-toggle="modal"
                                                data-target="#modal-delete">
                                            <#else>
                                                id="channel-delete-${channel.id}" data-channel-delete="safe-delete"
                                                data-channel-id="${channel.id}"
                                            >
                                                <@form.form method="POST" action=Routes.CHANNELS_DELETE.getRouteUrl(p.project.ownerName, p.project.slug, channel.name)
                                                    id="form-delete-${channel.id}"
                                                    class="form-channel-delete">
                                                <@csrf.formField />
                                            </@form.form>
                                        </#if>
                                        Delete
                                    </div>
                                </td>
                            </#if>
                            <script <#--@CSPNonce.attr-->>
                                window.loadDeleteManager = function() {
                                    initChannelDelete('#channel-delete-${channel.id}', '${channel.name}', ${versions});
                                    initChannelManager(
                                        "#channel-edit-${channel.id}", "${channel.name}", "${channel.color.hex}",
                                        "Edit channel", "${Routes.CHANNELS_SAVE.getRouteUrl(
                                                        p.project.ownerName, p.project.slug, channel.name)}",
                                        "post", "Save changes", ${channel.isNonReviewed?string('true', 'false')}
                                    );
                                }
                            </script>
                        </tr>
                        </#list>
                        </tbody>
                    </table>
                    <a href="${Routes.VERSIONS_SHOW_LIST.getRouteUrl(p.project.ownerName, p.project.slug)}"
                       class="float-left btn btn-default">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <a href="#" id="channel-new" class="float-right btn btn-primary"
                            <#if channels?size gte config.projects.maxChannels>
                                disabled data-toggle="tooltip" data-placement="left"
                                title="<@spring.message "channel.edit.maxReached" />"
                            <#else>
                                data-toggle="modal" data-target="#channel-settings"
                            </#if>
                    >
                        <i class="fas fa-plus"></i>
                    </a>
                    <@modalManage.modalManage />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="label-delete">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="label-delete"><@spring.message "channel.delete" /></h4>
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="<@spring.message "general.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><@spring.message "channel.delete.info" /></p>
                    <p class="minor">
                        <strong class="version-count"></strong> <i><@spring.message "channel.delete.info.versions" /></i>
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <@spring.message "general.cancel" />
                    </button>
                    <form method="post" action="#" class="form-channel-delete">
                        <@csrf.formField />
                        <button type="submit" class="btn btn-danger"><@spring.message "channel.delete" /></button>
                    </form>
                </div>
            </div>
        </div>
    </div>

</@base.base>