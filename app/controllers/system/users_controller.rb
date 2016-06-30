class System::UsersController < SystemController

  def index
    #
    # Can't search or order on name via a DB query when names are encrypted.
    #
    @users = User.paginate(default_pagination_params.merge(order: 'id ASC'))
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:active, !@user.active?)
    action = @user.active? ? 'activated' : 'deactivated'
    flash[:notice] = "You have successfully #{action} user: #{@user.display_name}" 
    redirect_to :back
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = t :user_edit, :scope=>[:notices]
      redirect_to system_users_path
    else
      transfer_user_encrypted_email_errors_to_email
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = t :user_create, :scope=>[:notices]
      redirect_to system_users_path
    else
      transfer_user_encrypted_email_errors_to_email
      render 'new'
    end
  end

  private

  def search_conditions_array(term)
    where_clause = []
    variables = []
    params[:search].split.each do |t| 
      where_clause << "((UPPER(first_name) like UPPER(?)) OR (UPPER(last_name) like UPPER(?)))"
      variables << "%#{t}%"
      variables << "%#{t}%"
    end 
    variables.inject([where_clause.join(' AND ')]){|sum, item|  sum << item}
  end

  def transfer_user_encrypted_email_errors_to_email
    errors = @user && @user.errors[:encrypted_email]
    @user.errors.add(:email,  errors.first) if errors.present?
  end
end
