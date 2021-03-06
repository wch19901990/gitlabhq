# frozen_string_literal: true

module Gitlab
  module StaticSiteEditor
    module Config
      class GeneratedConfig
        def initialize(repository, ref, path, return_url)
          @repository = repository
          @ref = ref
          @path = path
          @return_url = return_url
        end

        def data
          merge_requests_illustration_path = ActionController::Base.helpers.image_path('illustrations/merge_requests.svg')
          {
            branch: ref,
            path: path,
            commit_id: commit_id,
            project_id: project.id,
            project: project.path,
            namespace: project.namespace.full_path,
            return_url: sanitize_url(return_url),
            is_supported_content: supported_content?,
            base_url: Gitlab::Routing.url_helpers.project_show_sse_path(project, full_path),
            merge_requests_illustration_path: merge_requests_illustration_path
          }
        end

        private

        attr_reader :repository, :ref, :path, :return_url

        delegate :project, to: :repository

        def supported_extensions
          %w[.md].freeze
        end

        def commit_id
          repository.commit(ref)&.id
        end

        def supported_content?
          master_branch? && extension_supported? && file_exists?
        end

        def master_branch?
          ref == 'master'
        end

        def extension_supported?
          return true if path.end_with?('.md.erb') && Feature.enabled?(:sse_erb_support, project)

          supported_extensions.any? { |ext| path.end_with?(ext) }
        end

        def file_exists?
          commit_id.present? && !repository.blob_at(commit_id, path).nil?
        end

        def full_path
          "#{ref}/#{path}"
        end

        def sanitize_url(url)
          url if Gitlab::UrlSanitizer.valid_web?(url)
        end
      end
    end
  end
end
