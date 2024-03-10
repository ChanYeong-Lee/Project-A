using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class HorseStep : MonoBehaviour
{
    private AudioSource source;
    private HorseSlope slope;
    private Vector3 prev = Vector3.zero;
    private bool isPlayed = false;
    private float stepTime = 0.25f;
    private float stepTimeDelta = 0.0f;

    [SerializeField] private float threshold;
    [SerializeField] private AudioClip clip;


    private void Awake()
    {
        source = GetComponent<AudioSource>();
        slope = GetComponentInParent<HorseSlope>();
    }

    private void OnEnable()
    {
        prev = transform.position;
    }

    private void Update()
    {
        threshold = Time.deltaTime * 0.25f;
        if (Physics.Raycast(transform.position, -transform.up, 0.25f, slope.GroundLayers))
        {
            if (isPlayed == false && threshold < prev.y - transform.position.y && stepTimeDelta < 0.0f)
            {
                isPlayed = true;
                source.PlayOneShot(clip, 0.3f);
                stepTimeDelta = stepTime;
            }
        }

        if (threshold < transform.position.y - prev.y)
        {
            isPlayed = false;
        }

        stepTimeDelta -= Time.deltaTime;
        prev = transform.position;
    }



}