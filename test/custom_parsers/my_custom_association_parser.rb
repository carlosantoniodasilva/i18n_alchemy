class MyCustomAssociationParser < I18n::Alchemy::AssociationParser
  def parse(attributes)
    if association.options[:polymorphic]
      @proxy = target_class.i18n_alchemy_proxy.localized
    end

    super
  end

  def self.localize(object)
    object
  end
end
