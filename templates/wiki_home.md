# Welcome to the {{ project }} wiki!

{% if scripts %}
## Scripts
{% if scripts is string %}{% set scripts=scripts.split() %}{% endif %}
{% for script in scripts %}
- [{{ script }}](Scripts/{{ script }})
{% endfor %}
{% endif %}

{% if libraries %}
## Library
{% if libraries is string %}{% set libraries=libraries.split() %}{% endif %}
{% for library in libraries %}
- [{{ library }}](Library/{{ library }})
{% endfor %}
{% endif %}
