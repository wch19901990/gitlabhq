# frozen_string_literal: true

class SnippetBlobPresenter < BlobPresenter
  include GitlabRoutingHelper

  def rich_data
    return unless blob.rich_viewer

    render_rich_partial
  end

  def plain_data
    return if blob.binary?

    highlight(plain: false)
  end

  def raw_path
    snippet_blob_raw_route(only_path: true)
  end

  def raw_url
    snippet_blob_raw_route
  end

  private

  def snippet_multiple_files?
    blob.container.repository_exists? && Feature.enabled?(:snippet_multiple_files, current_user)
  end

  def snippet
    blob.container
  end

  def language
    nil
  end

  def render_rich_partial
    renderer.render("projects/blob/viewers/_#{blob.rich_viewer.partial_name}",
                    locals: { viewer: blob.rich_viewer, blob: blob, blob_raw_path: raw_path, blob_raw_url: raw_url },
                    layout: false)
  end

  def renderer
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap do |proxy_instance|
      proxy_instance.set_user(current_user, scope: :user)
    end

    ApplicationController.renderer.new('warden' => proxy)
  end

  def snippet_blob_raw_route(only_path: false)
    return gitlab_raw_snippet_blob_url(snippet, blob.path, only_path: only_path) if snippet_multiple_files?

    gitlab_raw_snippet_url(snippet, only_path: only_path)
  end
end
