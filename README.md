Type Enforcer
=============
_Dr [Bernhardt](https://twitter.com/garybernhardt) or: How I Learned to Stop Worrying and Love the Ruby Interpreter_


Provides assertions about the types of objects (something some would refer to as **_static typing_**)

Examples
--------
Anyway, have some code samples! (after `gem install type-enforcer`)

```ruby
require 'type-enforcer'

using TypeEnforcer
  # Uses refinements
  # Keep in mind this is experimental in Ruby 2.0.0!

@user.p!.name
  # Raises error unless @user is not null

@item.try(:blank?)
  # Calls blank? on @item if method exists

params[:id].e!(:fixnum?)
  # Raises error if params[:id] is not a fixnum
  # (Internally, this calls params[:id].fixnum?)
```

Here's a quick rundown of available methods (proper docs to come... as soon as refinements can be documented)
```ruby
@obj.enforce(String)                        # Returns nil unless @obj.acts_as?(String) (also aliased to @obj.e(String))
@obj.enforce(:fixnum?)                      # Returns nil unless @obj.fixnum? is true (also aliased to @obj.e(:fixnum?))
@obj.enforce!(Fixnum)                       # Throws error if @obj is not a Fixnum; returns @obj otherwise (also aliaed to @obj.e!(Fixnum))
@obj.enforce(String, error: 'derp')         # Returns 'derp' unless @obj.acts_as?(String) (also aliased to @obj.e(String))
@obj.enforce(error: AuthError, &block)      # Raises AuthError unless &block returns thruthy (gets called with `@obj)
@obj.enforce(:fixnum?)                      # Returns nil unless @obj.fixnum? is true (also aliased to @obj.e(:fixnum?))
@obj.enforce!(Fixnum)                       # Throws `NotFulfilledError` if @obj is not a Fixnum; returns @obj otherwise (also aliaed to @obj.e!(Fixnum))
@obj.enforce!(:whole?)                      # Throws error if @obj.whole? is false; returns @obj otherwise (also aliased to @obj.e!(:whole?))
@obj.acts_as?(Numeric)                      # Return true if Numeric === @obj (used instead of === directly so it can be overridden)
@obj.present?                               # Returns true unless @obj.nil?
@obj.present!                               # Raises `NotPresentError` unless @obj.present? (also aliased to @obj.p!)
@obj.present!(error: 'derp')                # Returns 'derp' if unless @obj.present?
@obj.present!(error: AuthError)             # Raises AuthError unless @obj.present?
@obj.try(:split, 'a')                       # Calls @obj.split('a'); returns nil if any errors are raised
@obj.try(:to_s, num, rescue: ArgumentError) # Calls @obj.split(num); returns nil if ArgumentError is raised
@obj.try {|o| o.split(num)}                 # Returns @obj.split(num) if no errors are raised; returns nil otherwise
@obj.blank?                                 # Returns @obj.nil? or @obj.try(:empty?)

@string.numeric?                            # Returns true if @string is a number
@string.fixnum?                             # Returns true if @string is an integer
@string.blank?                              # Returns true if @string contains only whitespace characters
@number.whole?                              # Return true if number is evenly divisible by an integer (ie, does not contain a decimal)
```

Notes
-----
`type-enforcer` is currently limited to Ruby 2.0.0, and uses the experimental refinements, which is subject to exploding at a moment's noticed.