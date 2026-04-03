from rest_framework import serializers
from .models import Project


class ProjectSerializer(serializers.ModelSerializer):
    image_url = serializers.ReadOnlyField()

    class Meta:
        model = Project
        fields = [
            'id',
            'title',
            'description',
            'image',
            'image_url',
            'github_url',
            'live_url',
            'display_order',
            'is_featured',
            'created_at',
            'updated_at',
        ]
        extra_kwargs = {
            'image': {'write_only': True},
        }