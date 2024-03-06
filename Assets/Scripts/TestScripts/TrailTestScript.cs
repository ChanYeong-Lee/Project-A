using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrailTestScript : MonoBehaviour
{
    private ParticleSystem particleSystem;
    private ParticleSystem.ForceOverLifetimeModule forceOverLifetime;
    private float y = 0;
    private void Start()
    {
        particleSystem = GetComponent<ParticleSystem>();
    }

    private void Update()
    {
        forceOverLifetime = particleSystem.forceOverLifetime;
        forceOverLifetime.x = new ParticleSystem.MinMaxCurve(100.0f, 100.0f);
        forceOverLifetime.y = new ParticleSystem.MinMaxCurve(0.0f, 500);
        forceOverLifetime.z = new ParticleSystem.MinMaxCurve(0.0f, 0.0f); 
    }
}
