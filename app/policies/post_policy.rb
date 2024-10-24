class PostPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def manage?
    user_is_author? && (record.user == user)
  end

  def show?
    true
  end

  def create?
    user_is_author?
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end

  private

  def user_is_author?
    user.author?
  end
end
