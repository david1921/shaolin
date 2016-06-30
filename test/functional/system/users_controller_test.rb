require_relative '../../test_helper'

class System::UsersControllerTest < ActionController::TestCase

  context 'RESTful actions' do
    setup do
      @system_user = FactoryGirl.create(:system_user)
      sign_in_as(@system_user)
    end

    context '#index' do
      should 'render the index template' do
        get :index
        assert_response :ok
        assert_template 'index'
      end

      should 'paginate users' do
        users = mock
        users.expects(:total_pages).at_least_once.returns(0)
        users.expects(:size).at_least_once.returns(0)
        users.expects(:each).at_least_once
        User.expects(:paginate).returns(users)
        get :index
        assert_equal users, assigns(:users)
      end
    end

    context '#edit' do
      should 'render the edit template' do
        get :edit, id: @system_user.to_param
        assert_response :ok
        assert_template 'edit'
      end
    end

    context '#update' do
      should 'update the user' do
        put :update, id: @system_user, user: {first_name: 'another name'}
        assert_equal 'another name', User.find(@system_user.id).first_name
        assert_response :redirect
        assert_redirected_to system_users_path
      end

      should 'fail to update and render the edit form' do
        put :update, id: @system_user, user: {username: ''}# username cannot be blank
        assert_response :ok
        assert_template 'edit'
      end
    end

    context '#new' do
      should 'render the new template' do
        get :new
        assert_response :ok
        assert_template 'new'
      end
    end

    context '#create' do
      should 'create a new user' do
        valid_attrs = FactoryGirl.attributes_for :password_confirmed_system_user
        post :create, user: valid_attrs
        assert_response :redirect
        assert_redirected_to system_users_path
      end

      should 'fail to create a new user and render new' do
        post :create, user: {}
        assert_response :ok
        assert_template 'new'
      end
    end

    context '#destroy' do
      should 'deactivate the user' do
        assert @system_user.active?  
        @request.env['HTTP_REFERER'] = 'http://test.com/users/'
        delete :destroy, id: @system_user.to_param
        assert !@system_user.reload.active?, 'should become inactive'
        assert_response :redirect
        assert_redirected_to 'http://test.com/users/' 
      end

      should 'activate the user' do
        @another_user = FactoryGirl.create(:sales_user, active: false)
        assert !@another_user.active?  
        @request.env['HTTP_REFERER'] = 'http://test.com/users/'
        delete :destroy, id: @another_user.to_param
        assert @another_user.reload.active?, 'should become active'
        assert_response :redirect
        assert_redirected_to 'http://test.com/users/' 
      end
    end
  end
#
# User search is broken for the time being, because names are now encrypted
#
=begin
  context 'searching for users' do
    setup do
      @user1 = create(:system_user, first_name: 'aaaaaa', last_name: 'bbbbbb')
      @user2 = create(:system_user, first_name: 'cccccc', last_name: 'dddddd')
      @user3 = create(:system_user, first_name: 'aaaaaa', last_name: 'ffffff')
    end

    should 'find all users' do
      sign_in_as @user1
      get :index, search: 'aaaaa bbbbb'
      assert_response :ok
      assert_select "div[id='user_table']" do
        assert_select 'ul', 2
      end
    end

    should 'find one user' do
      sign_in_as @user1
      get :index, search: 'aaaaa bbbbb'
      assert_response :ok
      assert_select "div[id='user_table']" do
        assert_select 'ul', 2
      end
    end

    should 'find nobody' do
      sign_in_as @user1
      get :index, search: 'aaaaa bbbbb ccccc'
      assert_select "div[id='user_table']" do
        assert_select 'ul', 1
      end
    end

    should 'find two users' do
      sign_in_as @user1
      get :index, search: 'aaaaa'
      assert_select "div[id='user_table']" do
        assert_select 'ul', 3
      end
    end
  end
=end

  context 'authenticate system users' do
    should 'authorize_system_user before filter' do
      @user = create :system_user
      actions = { get: :index, get: :edit, get: :new, put: :update, post: :create }
      @controller.expects(:authorize_system_user).at_least(actions.size)
      @controller.expects(:authorize).at_least(actions.size)
      actions.each do |method, action|
        send(method, action, id: @user.to_param)
      end
    end
  end
end
