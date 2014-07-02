# -*- coding: utf-8 -*-
class Backend::PublicationFlagsController < Backend::BackendController

  # PUT backend/:name/:id/:field
  def update
    model = Object.const_get(params[:name].classify).find(params[:id])
    if model.toggle!(params[:field])
      return render json: {msgs: t('msg.saved'), id: model.id}
    else
      return render json: {errors: t('msg.save_error')}
    end
  end
end