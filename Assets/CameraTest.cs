using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTest : MonoBehaviour
{
    private CinemachineVirtualCamera vCam;
    private CinemachineTrackedDolly track;
    private void Awake()
    {
        vCam = GetComponent<CinemachineVirtualCamera>();
        track = vCam.GetCinemachineComponent<CinemachineTrackedDolly>();
    }
    // Start is called before the first frame update

    private void Start()
    {
        track.m_PathPosition = 0.0f;
    }

    // Update is called once per frame
    private void Update()
    {
        track.m_PathPosition += Time.deltaTime;
    }

}
