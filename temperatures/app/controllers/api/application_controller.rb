class Api::ApplicationController < ApplicationController

  protected
  def run_object_serializer(object, each_serializer, options = {})
    options = {
      serializer: each_serializer,
      params: options
    }
    ActiveModelSerializers::SerializableResource.new(object, each_serializer: each_serializer).as_json
  end

  def render_created(serialized_data = {}, errors = nil, success = nil, options = {})
    meta = options.fetch(:meta, nil)
    json = {
      date: Time.now.utc,
      status: 201,
      messages: { errors: errors, success: success },
      data: serialized_data,
      meta: meta
    }

    render(json: json)
  end

  def render_success(serialized_data = {}, errors = nil, success = nil, options = {})
    meta = options.fetch(:meta, nil)
    json = {
      date: Time.now.utc,
      status: 200,
      messages: { errors: errors, success: success },
      data: serialized_data,
      meta: meta
    }

    render(json: json)
  end

  def render_validation_failed(errors = nil, success = nil, options = {})
    meta = options.fetch(:meta, nil)
    json = {
      date: Time.now.utc,
      status: 400,
      messages: { errors: errors, success: success },
      meta: meta
    }

    render(json: json)
  end

  def render_unprocessable_entity(errors)
    render(
      json: {
        date: Time.now.utc,
        status: 422,
        messages: { errors: errors }
      },
      status: :unprocessable_entity
    )
  end
end