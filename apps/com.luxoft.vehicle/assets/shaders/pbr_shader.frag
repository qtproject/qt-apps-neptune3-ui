/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

#define FP highp
#define PI 3.1415926535897932384626433832795

uniform FP vec3 eyePosition;

varying FP vec3 worldPosition;
varying FP vec3 worldNormal;
varying FP vec4 worldTangent;

// PBR material
uniform FP float metalness;
uniform FP float roughness;
uniform FP vec3 albedo;
uniform FP float ao;
uniform FP float alpha;

FP float DistributionGGX(FP vec3 N, FP vec3 H, FP float roughness)
{
    FP float a = roughness * roughness;
    FP float a2 = a * a;
    FP float NdotH = max(dot(N, H), 0.0);
    FP float NdotH2 = NdotH * NdotH;

    FP float nom = a2;
    FP float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / denom;
}

FP float GeometrySchlickGGX(FP float NdotV, FP float roughness)
{
    FP float r = (roughness + 1.0);
    FP float k = (r*r) / 8.0;

    FP float nom = NdotV;
    FP float denom = NdotV * (1.0 - k) + k;

    return nom / denom;
}

FP float GeometrySmith(FP vec3 N, FP vec3 V, FP vec3 L, FP float roughness)
{
    FP float NdotV = max(dot(N, V), 0.0);
    FP float NdotL = max(dot(N, L), 0.0);
    FP float ggx2 = GeometrySchlickGGX(NdotV, roughness);
    FP float ggx1 = GeometrySchlickGGX(NdotL, roughness);

    return ggx1 * ggx2;
}

FP vec3 FresnelSchlick(FP float cosTheta, FP vec3 F0)
{
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main()
{
    FP vec3 V = normalize(eyePosition - worldPosition);
    FP vec3 F0 = vec3(0.04);

    F0 = mix(F0, albedo, metalness);

    const int lightsCount = 3;

    FP vec3 lightPositions[lightsCount];

    // 2000.0 is radiant flux
    const FP vec3 lightColor = vec3(300.0, 300.0, 300.0);

    const FP float dist = 8.0;

    lightPositions[0] = vec3(0, dist, 0); // Top light
    lightPositions[1] = vec3(-dist, dist, dist); // Left back
    lightPositions[2] = vec3(dist, dist, -dist);  // Right front

    // reflectance equation
    FP vec3 Lo = vec3(0.0);
    for(int i = 0; i < lightsCount; ++i)
    {
        // calculate per-light radiance
        FP vec3 L = normalize(lightPositions[i] - worldPosition);
        FP vec3 H = normalize(V + L);

        FP float distance = length(lightPositions[i] - worldPosition);
        FP float attenuation = 1.0 / (distance * distance);
        FP vec3 radiance = lightColor * attenuation;

        // cook-torrance brdf
        FP float NDF = DistributionGGX(worldNormal, H, roughness);
        FP float G = GeometrySmith(worldNormal, V, L, roughness);
        FP vec3 F = FresnelSchlick(max(dot(H, V), 0.0), F0);

        FP vec3 kS = F;
        FP vec3 kD = vec3(1.0) - kS;
        kD *= 1.0 - metalness;

        FP vec3 nominator = NDF * G * F;
        FP float denominator = 4.0 * max(dot(worldNormal, V), 0.0)
            * max(dot(worldNormal, L), 0.0);
        FP vec3 specular = nominator / max(denominator, 0.001);

        // add to outgoing radiance Lo
        FP float NdotL = max(dot(worldNormal, L), 0.0);
        Lo += (kD * albedo / PI + specular) * radiance * NdotL;
    }

    FP vec3 ambient = vec3(0.03) * albedo * ao;
    FP vec3 color = ambient + Lo;

    // Gamma correction
    color = color / (color + vec3(1.0));
    color = pow(color, vec3(1.0/2.2));

    gl_FragColor = vec4(color, alpha);
}
