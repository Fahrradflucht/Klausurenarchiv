defmodule Klausurenarchiv.Router do
  use Klausurenarchiv.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Klausurenarchiv.AuthPlug, repo: Klausurenarchiv.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Klausurenarchiv do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/courses", CourseController, except: [:show] do
      resources "/instructors", InstructorController, except: [:show] do
        resources "/uploads", UploadController
      end
    end

  end

  scope "/auth", Klausurenarchiv do
    pipe_through :browser
    
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
