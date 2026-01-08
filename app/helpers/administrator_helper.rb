module AdministratorHelper
  def active_submission_tab?(path)
    request.path == path
  end
end
