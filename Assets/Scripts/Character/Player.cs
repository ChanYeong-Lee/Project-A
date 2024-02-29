using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MyProject
{
    public class Player : MonoBehaviour
    {
        [HideInInspector]
        public PlayerInput input;
        [HideInInspector]
        public PlayerMove move;
        [HideInInspector]
        public Rigidbody rb;
        [HideInInspector]
        public Transform cameraTarget;

        private void Awake()
        {
            input = GetComponent<PlayerInput>();
            move = GetComponent<PlayerMove>();
            rb = GetComponent<Rigidbody>();
            cameraTarget = transform.Find("CameraTarget");
        }
    }
}