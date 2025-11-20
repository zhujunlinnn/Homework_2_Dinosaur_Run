using UnityEngine;
using UnityEngine.Windows;

public class Hero_State_Controller : MonoBehaviour
{
    Animator animator;
    int isRunningHash;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        animator = GetComponent<Animator>();

        // Increases performance
        isRunningHash = Animator.StringToHash("isRunning");
    }

    // Update is called once per frame
    void Update()
    {
        bool isRunning = animator.GetBool(isRunningHash);
        bool forwardPressed = UnityEngine.Input.GetKey(KeyCode.W);

        // If player presses left shift key
        if (!isRunning && forwardPressed)
        {
            // Then set the isRunning boolean to be true
            animator.SetBool(isRunningHash, true);
        }

        // If player is not pressing left shift key
        if (isRunning && !forwardPressed)
        {
            // Then set the isRunning boolean to be false
            animator.SetBool(isRunningHash, false);
        }
    }
}