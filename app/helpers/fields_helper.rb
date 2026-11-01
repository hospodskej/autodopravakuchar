module FieldsHelper
  # Label, input, optional hint and inline error for one form attribute, wired up for screen readers.
  def form_field(form, attribute, label:, input: :text_field, hint: nil, required: false, **options)
    object = form.object
    errors = object.errors[attribute]
    field_id = "#{form.object_name}_#{attribute}"
    described_by = [ ("#{field_id}_hint" if hint), ("#{field_id}_error" if errors.any?) ].compact

    options[:required] = true if required
    options[:aria] = { invalid: (true if errors.any?), describedby: described_by.join(" ").presence }.compact

    tag.div(class: [ "field", ("field--error" if errors.any?) ]) do
      safe_join([
        form.label(attribute, safe_join([ label, (tag.span(" *", class: "field__required", aria: { hidden: true }) if required) ])),
        (tag.p(hint, id: "#{field_id}_hint", class: "field__hint") if hint),
        input == :select ? form.select(attribute, options.delete(:choices), { include_blank: "Vyberte…" }, options) : form.public_send(input, attribute, options),
        (tag.p(errors.to_sentence, id: "#{field_id}_error", class: "field__error") if errors.any?)
      ].compact)
    end
  end
end
